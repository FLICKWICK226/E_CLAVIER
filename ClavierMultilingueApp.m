classdef ClavierMultilingueApp < matlab.apps.AppBase
    % CLAVIERMULTILINGUEAPP Interface PC (MATLAB App Designer) du Clavier Multilingue
    % Langues : Moore, Dioula, Fulfulde (Alphabet National Burkinabe - ANB)
    % Architecture : Vue/Controleur connectes au Modele MATLAB Coder (engine_*.m)
    % Support : Clavier Virtuel (Souris) + Clavier Physique (WindowKeyPressFcn)

    properties (Access = public)
        UIFigure             matlab.ui.Figure
        TabGroup             matlab.ui.container.TabGroup
        TabKeyboard          matlab.ui.container.Tab
        TabAbout             matlab.ui.container.Tab
        
        % --- ONGLET 1 : CLAVIER ---
        MainGrid             matlab.ui.container.GridLayout
        HeaderGrid           matlab.ui.container.GridLayout
        TitleLabel           matlab.ui.control.Label
        LangDropdown         matlab.ui.control.DropDown
        StatusLabel          matlab.ui.control.Label
        CopyButton           matlab.ui.control.Button
        ClearButton          matlab.ui.control.Button
        
        DisplayTextArea      matlab.ui.control.TextArea
        
        KeyboardPanel        matlab.ui.container.Panel
        KeyboardGrid         matlab.ui.container.GridLayout
        RowSpecialGrid       matlab.ui.container.GridLayout
        Row1Grid             matlab.ui.container.GridLayout
        Row2Grid             matlab.ui.container.GridLayout
        Row3Grid             matlab.ui.container.GridLayout
        Row4Grid             matlab.ui.container.GridLayout
        RowSysGrid           matlab.ui.container.GridLayout
        
        SpecialButtons       
        DiacriticButtons     
        
        ShiftButton          matlab.ui.control.StateButton
        SpaceButton          matlab.ui.control.Button
        EnterButton          matlab.ui.control.Button
        BackspaceButton      matlab.ui.control.Button

        % --- ONGLET 2 : OFFRIR UN CAFE & A PROPOS ---
        AboutGrid            matlab.ui.container.GridLayout
        AboutCardPanel       matlab.ui.container.Panel
        AboutCardGrid        matlab.ui.container.GridLayout
        AboutHeaderLabel     matlab.ui.control.Label
        AboutSubLabel        matlab.ui.control.Label
        AboutTextArea        matlab.ui.control.TextArea
        AboutBtnGrid         matlab.ui.container.GridLayout
        RepoButton           matlab.ui.control.Button
        ContribButton        matlab.ui.control.Button
        CoffeeButton         matlab.ui.control.Button
    end

    properties (Access = private)
        State                struct
        BaseCharsRow1        char = '1234567890'
        BaseCharsRow2        char = 'azertyuiop'
        BaseCharsRow3        char = 'qsdfghjklm'
        BaseCharsRow4        char = 'wxcvbn,.;:?!-'
        Row1Btns             
        Row2Btns             char = '+226 55312457' 
        Row3Btns             
        Row4Btns             
        RepoURL              char = 'https://github.com/FLICKWICK226/E_CLAVIER.git'
        ContribURL           char = 'https://github.com/FLICKWICK226/E_CLAVIER/blob/main/CONTRIBUTING.md'
        ContactInfo          char = '' % <--- LIGNE 61 : COLLE TON CONTACT ICI (ex: '+226 XX XX XX XX')
    end

    methods (Access = private)

        function initModel(app)
            app.State = init_clavier_state();
            app.updateKeyboardLabels();
            app.refreshDisplay();
        end

        function refreshDisplay(app)
            if app.State.cursor_len == 0
                app.DisplayTextArea.Value = {''};
                app.StatusLabel.Text = 'Clavier physique actif (F1-F5: Lettres ANB | F6-F9: Tons) | Pret';
            else
                active_codes = app.State.buffer(1 : app.State.cursor_len);
                str_out = char(active_codes);
                lines = split(string(str_out), char(10));
                app.DisplayTextArea.Value = cellstr(lines);
                app.StatusLabel.Text = sprintf('Longueur : %d code points (UTF-16) | Clavier physique actif', app.State.cursor_len);
            end
        end

        function updateKeyboardLabels(app)
            % 1. Mise a jour des 5 touches speciales selon la langue et Shift
            special_codes = engine_get_active_keys(app.State.lang_id, app.State.is_shift);
            for i = 1:5
                code = special_codes(i);
                if code == 0
                    app.SpecialButtons(i).Text = '';
                    app.SpecialButtons(i).Enable = 'off';
                    app.SpecialButtons(i).UserData = uint16(0);
                else
                    app.SpecialButtons(i).Text = sprintf('%s (F%d)', char(code), i);
                    app.SpecialButtons(i).Enable = 'on';
                    app.SpecialButtons(i).UserData = code;
                end
            end

            % 2. Mise a jour de la casse des touches alphabetiques (A-Z)
            for i = 1:numel(app.Row2Btns)
                c = app.BaseCharsRow2(i);
                if app.State.is_shift
                    c = upper(c);
                end
                app.Row2Btns(i).Text = c;
                app.Row2Btns(i).UserData = uint16(double(c));
            end

            for i = 1:numel(app.Row3Btns)
                c = app.BaseCharsRow3(i);
                if app.State.is_shift
                    c = upper(c);
                end
                app.Row3Btns(i).Text = c;
                app.Row3Btns(i).UserData = uint16(double(c));
            end

            for i = 1:numel(app.Row4Btns)
                c = app.BaseCharsRow4(i);
                if app.State.is_shift && isletter(c)
                    c = upper(c);
                end
                app.Row4Btns(i).Text = c;
                app.Row4Btns(i).UserData = uint16(double(c));
            end
        end

        function insertCodePoint(app, code_in)
            if code_in == 0
                return;
            end
            prev_len = app.State.cursor_len;
            app.State = engine_insert_char(app.State, uint16(code_in));
            
            if app.State.cursor_len == prev_len && (code_in >= 768 && code_in <= 879)
                app.StatusLabel.Text = 'Action bloquee : Un diacritique ne peut suivre qu''une voyelle (max 2).';
            else
                app.refreshDisplay();
            end
        end

        function onCharKeyPressed(app, src, ~)
            code_in = uint16(src.UserData);
            app.insertCodePoint(code_in);
        end

        function onPhysicalKeyPressed(app, ~, event)
            if app.TabGroup.SelectedTab ~= app.TabKeyboard
                return;
            end

            key = event.Key;

            if strcmp(key, 'backspace')
                app.onBackspacePressed([], []);
                return;
            end

            if strcmp(key, 'return')
                app.insertCodePoint(uint16(10));
                return;
            end

            if strcmp(key, 'space')
                app.insertCodePoint(uint16(32));
                return;
            end

            if ismember(key, {'f1', 'f2', 'f3', 'f4', 'f5'})
                idx = str2double(key(2));
                special_codes = engine_get_active_keys(app.State.lang_id, app.State.is_shift);
                if special_codes(idx) ~= 0
                    app.insertCodePoint(special_codes(idx));
                end
                return;
            end

            if ismember(key, {'f6', 'f7', 'f8', 'f9'})
                diacritic_codes = uint16([768, 769, 770, 771]);
                idx = str2double(key(2)) - 5;
                app.insertCodePoint(diacritic_codes(idx));
                return;
            end

            ch = event.Character;
            if ~isempty(ch)
                code_val = double(ch(1));
                if code_val >= 32
                    app.insertCodePoint(uint16(code_val));
                end
            end
        end

        function onBackspacePressed(app, ~, ~)
            app.State = engine_backspace(app.State);
            app.refreshDisplay();
        end

        function onShiftToggled(app, ~, ~)
            app.State.is_shift = app.ShiftButton.Value;
            if app.State.is_shift
                app.ShiftButton.BackgroundColor = [0.18 0.45 0.71];
                app.ShiftButton.FontColor = [1 1 1];
            else
                app.ShiftButton.BackgroundColor = [0.90 0.90 0.90];
                app.ShiftButton.FontColor = [0 0 0];
            end
            app.updateKeyboardLabels();
        end

        function onLangChanged(app, ~, ~)
            val = app.LangDropdown.Value;
            if strcmp(val, 'Moore')
                app.State.lang_id = uint8(1);
            elseif strcmp(val, 'Dioula')
                app.State.lang_id = uint8(2);
            else
                app.State.lang_id = uint8(3);
            end
            app.updateKeyboardLabels();
            app.StatusLabel.Text = sprintf('Langue active : %s', val);
        end

        function onCopyPressed(app, ~, ~)
            if app.State.cursor_len == 0
                app.StatusLabel.Text = 'Presse-papiers : Rien a copier (zone vide).';
                return;
            end
            active_codes = app.State.buffer(1 : app.State.cursor_len);
            str_out = char(active_codes);
            clipboard('copy', str_out);
            app.StatusLabel.Text = 'Texte copie dans le presse-papiers ! Pret a coller (Ctrl+V).';
        end

        function onClearPressed(app, ~, ~)
            current_lang = app.State.lang_id;
            app.State = init_clavier_state();
            app.State.lang_id = current_lang;
            app.State.is_shift = app.ShiftButton.Value;
            app.refreshDisplay();
            app.StatusLabel.Text = 'Zone de saisie effacee.';
        end

        function onOpenRepo(app, ~, ~)
            web(app.RepoURL, '-browser');
        end

        function onOpenContrib(app, ~, ~)
            web(app.ContribURL, '-browser');
        end

        function onCopyContact(app, ~, ~)
            % Action unique : copie le contact defini a la ligne 61 dans le presse-papiers
            clipboard('copy', app.ContactInfo);
            if isempty(app.ContactInfo)
                app.CoffeeButton.Text = 'Contact vide (Renseignez la ligne 61)';
            else
                app.CoffeeButton.Text = ['Contact copie : ' app.ContactInfo];
            end
        end

        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100, 100, 940, 620];
            app.UIFigure.Name = 'E_CLAVIER - Clavier Multilingue (Moore - Dioula - Fulfulde) | EPO Ouaga';
            app.UIFigure.Color = [0.95 0.96 0.98];
            app.UIFigure.WindowKeyPressFcn = @(src, event) app.onPhysicalKeyPressed(src, event);

            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1, 1, 940, 620];

            app.TabKeyboard = uitab(app.TabGroup);
            app.TabKeyboard.Title = 'Clavier Multilingue (Saisie)';
            app.TabKeyboard.BackgroundColor = [0.95 0.96 0.98];

            app.TabAbout = uitab(app.TabGroup);
            app.TabAbout.Title = 'Offrir un cafe & Open Source (EPO)';
            app.TabAbout.BackgroundColor = [0.95 0.96 0.98];

            % =================================================================
            % ONGLET 1 : INTERFACE DU CLAVIER
            % =================================================================
            app.MainGrid = uigridlayout(app.TabKeyboard, [3, 1]);
            app.MainGrid.RowHeight = {55, '1x', 310};
            app.MainGrid.Padding = [12 12 12 12];
            app.MainGrid.RowSpacing = 10;

            app.HeaderGrid = uigridlayout(app.MainGrid, [1, 5]);
            app.HeaderGrid.ColumnWidth = {220, 140, '1x', 135, 115};
            app.HeaderGrid.Padding = [0 0 0 0];

            app.TitleLabel = uilabel(app.HeaderGrid);
            app.TitleLabel.Text = 'Clavier National ANB';
            app.TitleLabel.FontSize = 18;
            app.TitleLabel.FontWeight = 'bold';

            app.LangDropdown = uidropdown(app.HeaderGrid);
            app.LangDropdown.Items = {'Moore', 'Dioula', 'Fulfulde'};
            app.LangDropdown.Value = 'Moore';
            app.LangDropdown.FontSize = 14;
            app.LangDropdown.ValueChangedFcn = @(src, event) app.onLangChanged(src, event);

            app.StatusLabel = uilabel(app.HeaderGrid);
            app.StatusLabel.Text = 'Initialisation...';
            app.StatusLabel.FontSize = 12;
            app.StatusLabel.FontColor = [0.25 0.25 0.25];

            app.CopyButton = uibutton(app.HeaderGrid, 'push');
            app.CopyButton.Text = 'Copier le texte';
            app.CopyButton.FontWeight = 'bold';
            app.CopyButton.BackgroundColor = [0.16 0.62 0.38];
            app.CopyButton.FontColor = [1 1 1];
            app.CopyButton.ButtonPushedFcn = @(src, event) app.onCopyPressed(src, event);

            app.ClearButton = uibutton(app.HeaderGrid, 'push');
            app.ClearButton.Text = 'Tout effacer';
            app.ClearButton.FontWeight = 'bold';
            app.ClearButton.BackgroundColor = [0.82 0.23 0.23];
            app.ClearButton.FontColor = [1 1 1];
            app.ClearButton.ButtonPushedFcn = @(src, event) app.onClearPressed(src, event);

            app.DisplayTextArea = uitextarea(app.MainGrid);
            app.DisplayTextArea.Editable = 'off';
            app.DisplayTextArea.FontName = 'Segoe UI';
            app.DisplayTextArea.FontSize = 22;
            app.DisplayTextArea.Value = {''};

            app.KeyboardPanel = uipanel(app.MainGrid);
            app.KeyboardPanel.BackgroundColor = [0.88 0.90 0.93];
            app.KeyboardGrid = uigridlayout(app.KeyboardPanel, [6, 1]);
            app.KeyboardGrid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1.1x'};
            app.KeyboardGrid.Padding = [8 8 8 8];
            app.KeyboardGrid.RowSpacing = 6;

            % Rangee Speciale
            app.RowSpecialGrid = uigridlayout(app.KeyboardGrid, [1, 9]);
            app.RowSpecialGrid.Padding = [0 0 0 0];
            app.RowSpecialGrid.ColumnSpacing = 6;
            app.SpecialButtons = matlab.ui.control.Button.empty(1, 0);
            for i = 1:5
                btn = uibutton(app.RowSpecialGrid, 'push');
                btn.FontName = 'Segoe UI';
                btn.FontSize = 15;
                btn.FontWeight = 'bold';
                btn.BackgroundColor = [1.0 0.95 0.80];
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.SpecialButtons(i) = btn;
            end

            diacritic_labels = { ...
                ['Ton Bas ' char(96) ' (F6)'], ...
                ['Ton Haut ' char(180) ' (F7)'], ...
                'Circonflexe ^ (F8)', ...
                'Nasal ~ (F9)' ...
            };
            diacritic_codes = uint16([768, 769, 770, 771]);
            app.DiacriticButtons = matlab.ui.control.Button.empty(1, 0);
            for i = 1:4
                btn = uibutton(app.RowSpecialGrid, 'push');
                btn.Text = diacritic_labels{i};
                btn.FontName = 'Segoe UI';
                btn.FontSize = 12;
                btn.FontWeight = 'bold';
                btn.BackgroundColor = [0.82 0.92 1.0];
                btn.UserData = diacritic_codes(i);
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.DiacriticButtons(i) = btn;
            end

            % Rangee Chiffres (1-0)
            app.Row1Grid = uigridlayout(app.KeyboardGrid, [1, numel(app.BaseCharsRow1)]);
            app.Row1Grid.Padding = [0 0 0 0];
            app.Row1Grid.ColumnSpacing = 5;
            app.Row1Btns = matlab.ui.control.Button.empty(1, 0);
            for i = 1:numel(app.BaseCharsRow1)
                c = app.BaseCharsRow1(i);
                btn = uibutton(app.Row1Grid, 'push');
                btn.Text = c;
                btn.FontSize = 15;
                btn.UserData = uint16(double(c));
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.Row1Btns(i) = btn;
            end

            % Rangee AZERTY 1
            app.Row2Grid = uigridlayout(app.KeyboardGrid, [1, numel(app.BaseCharsRow2)]);
            app.Row2Grid.Padding = [0 0 0 0];
            app.Row2Grid.ColumnSpacing = 5;
            app.Row2Btns = matlab.ui.control.Button.empty(1, 0);
            for i = 1:numel(app.BaseCharsRow2)
                c = app.BaseCharsRow2(i);
                btn = uibutton(app.Row2Grid, 'push');
                btn.Text = c;
                btn.FontName = 'Segoe UI';
                btn.FontSize = 16;
                btn.UserData = uint16(double(c));
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.Row2Btns(i) = btn;
            end

            % Rangee AZERTY 2
            app.Row3Grid = uigridlayout(app.KeyboardGrid, [1, numel(app.BaseCharsRow3)]);
            app.Row3Grid.Padding = [0 0 0 0];
            app.Row3Grid.ColumnSpacing = 5;
            app.Row3Btns = matlab.ui.control.Button.empty(1, 0);
            for i = 1:numel(app.BaseCharsRow3)
                c = app.BaseCharsRow3(i);
                btn = uibutton(app.Row3Grid, 'push');
                btn.Text = c;
                btn.FontName = 'Segoe UI';
                btn.FontSize = 16;
                btn.UserData = uint16(double(c));
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.Row3Btns(i) = btn;
            end

            % Rangee AZERTY 3 + Ponctuation
            app.Row4Grid = uigridlayout(app.KeyboardGrid, [1, numel(app.BaseCharsRow4)]);
            app.Row4Grid.Padding = [0 0 0 0];
            app.Row4Grid.ColumnSpacing = 5;
            app.Row4Btns = matlab.ui.control.Button.empty(1, 0);
            for i = 1:numel(app.BaseCharsRow4)
                c = app.BaseCharsRow4(i);
                btn = uibutton(app.Row4Grid, 'push');
                btn.Text = c;
                btn.FontName = 'Segoe UI';
                btn.FontSize = 16;
                btn.UserData = uint16(double(c));
                btn.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);
                app.Row4Btns(i) = btn;
            end

            % Rangee Touches Systemes
            app.RowSysGrid = uigridlayout(app.KeyboardGrid, [1, 4]);
            app.RowSysGrid.ColumnWidth = {140, '1x', 140, 180};
            app.RowSysGrid.Padding = [0 0 0 0];
            app.RowSysGrid.ColumnSpacing = 8;

            app.ShiftButton = uibutton(app.RowSysGrid, 'state');
            app.ShiftButton.Text = 'MAJ (Shift)';
            app.ShiftButton.FontSize = 15;
            app.ShiftButton.FontWeight = 'bold';
            app.ShiftButton.ValueChangedFcn = @(src, event) app.onShiftToggled(src, event);

            app.SpaceButton = uibutton(app.RowSysGrid, 'push');
            app.SpaceButton.Text = 'ESPACE';
            app.SpaceButton.FontSize = 15;
            app.SpaceButton.FontWeight = 'bold';
            app.SpaceButton.UserData = uint16(32);
            app.SpaceButton.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);

            app.EnterButton = uibutton(app.RowSysGrid, 'push');
            app.EnterButton.Text = 'Entree';
            app.EnterButton.FontSize = 15;
            app.EnterButton.FontWeight = 'bold';
            app.EnterButton.UserData = uint16(10);
            app.EnterButton.ButtonPushedFcn = @(src, event) app.onCharKeyPressed(src, event);

            app.BackspaceButton = uibutton(app.RowSysGrid, 'push');
            app.BackspaceButton.Text = '<- Retour (Cluster)';
            app.BackspaceButton.FontSize = 15;
            app.BackspaceButton.FontWeight = 'bold';
            app.BackspaceButton.BackgroundColor = [0.95 0.82 0.82];
            app.BackspaceButton.ButtonPushedFcn = @(src, event) app.onBackspacePressed(src, event);

            % =================================================================
            % ONGLET 2 : PAGE "OFFRIR UN CAFE & A PROPOS"
            % =================================================================
            app.AboutGrid = uigridlayout(app.TabAbout, [1, 1]);
            app.AboutGrid.Padding = [40 30 40 30];

            app.AboutCardPanel = uipanel(app.AboutGrid);
            app.AboutCardPanel.BackgroundColor = [1 1 1];
            app.AboutCardGrid = uigridlayout(app.AboutCardPanel, [4, 1]);
            app.AboutCardGrid.RowHeight = {45, 30, '1x', 60};
            app.AboutCardGrid.Padding = [25 25 25 25];
            app.AboutCardGrid.RowSpacing = 12;

            app.AboutHeaderLabel = uilabel(app.AboutCardGrid);
            app.AboutHeaderLabel.Text = 'Projet E_CLAVIER - Initiative Etudiante (EPO Ouagadougou)';
            app.AboutHeaderLabel.FontSize = 20;
            app.AboutHeaderLabel.FontWeight = 'bold';
            app.AboutHeaderLabel.FontColor = [0.12 0.35 0.58];

            app.AboutSubLabel = uilabel(app.AboutCardGrid);
            app.AboutSubLabel.Text = 'Depot officiel Open Source : https://github.com/FLICKWICK226/E_CLAVIER.git';
            app.AboutSubLabel.FontSize = 14;
            app.AboutSubLabel.FontWeight = 'bold';
            app.AboutSubLabel.FontColor = [0.16 0.62 0.38];

            about_lines = {
                'A PROPOS DU PROJET :'
                'Ce projet est une initiative academique et citoyenne portee par un etudiant de l''Ecole Polytechnique de Ouagadougou (EPO).'
                'Entierement gratuit et distribue sous licence libre (Open Source), son code source est integralement auditable en toute transparence sur GitHub.'
                ''
                'ALTERNATIVE LEGERE (RUST / C++) :'
                'Pour les utilisateurs ne disposant pas de l''environnement MATLAB Runtime (MCR), une version native et ultra-legere est en developpement et sera disponible bientot dans le meme depot GitHub.'
                ''
                'EVOLUTION LINGUISTIQUE & CONTRIBUTIONS :'
                'L''implementation actuelle s''appuie sur la documentation disponible de l''Alphabet National Burkinabe (ANB). Ce projet a vocation a s''ameliorer continuellement : si vous disposez de mises a jour orthographiques, de remarques linguistiques ou de suggestions techniques, nous vous invitons a consulter le fichier CONTRIBUTING.md sur GitHub. Vos retours et critiques constructives constituent deja une contribution majeure a l''evolution de cet outil !'
                ''
                'SOUTENIR LE PROJET (OFFRIR UN CAFE) :'
                'Ce logiciel est gratuit, mais nous acceptons volontiers votre soutien. Cliquez sur le bouton orange ci-dessous pour copier le contact de l''auteur.'
            };

            app.AboutTextArea = uitextarea(app.AboutCardGrid);
            app.AboutTextArea.Editable = 'off';
            app.AboutTextArea.FontName = 'Segoe UI';
            app.AboutTextArea.FontSize = 15;
            app.AboutTextArea.Value = about_lines;

            app.AboutBtnGrid = uigridlayout(app.AboutCardGrid, [1, 3]);
            app.AboutBtnGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.AboutBtnGrid.ColumnSpacing = 15;
            app.AboutBtnGrid.Padding = [0 0 0 0];

            app.RepoButton = uibutton(app.AboutBtnGrid, 'push');
            app.RepoButton.Text = 'Ouvrir le Repo GitHub';
            app.RepoButton.FontSize = 14;
            app.RepoButton.FontWeight = 'bold';
            app.RepoButton.BackgroundColor = [0.15 0.18 0.22];
            app.RepoButton.FontColor = [1 1 1];
            app.RepoButton.ButtonPushedFcn = @(src, event) app.onOpenRepo(src, event);

            app.ContribButton = uibutton(app.AboutBtnGrid, 'push');
            app.ContribButton.Text = 'Lire CONTRIBUTING.md';
            app.ContribButton.FontSize = 14;
            app.ContribButton.FontWeight = 'bold';
            app.ContribButton.BackgroundColor = [0.18 0.45 0.71];
            app.ContribButton.FontColor = [1 1 1];
            app.ContribButton.ButtonPushedFcn = @(src, event) app.onOpenContrib(src, event);

            app.CoffeeButton = uibutton(app.AboutBtnGrid, 'push');
            app.CoffeeButton.Text = 'Offrir un cafe (Copier le contact)';
            app.CoffeeButton.FontSize = 14;
            app.CoffeeButton.FontWeight = 'bold';
            app.CoffeeButton.BackgroundColor = [0.85 0.52 0.12];
            app.CoffeeButton.FontColor = [1 1 1];
            app.CoffeeButton.ButtonPushedFcn = @(src, event) app.onCopyContact(src, event);

            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)

        function app = ClavierMultilingueApp
            createComponents(app);
            initModel(app);
            if nargout == 0
                clear app
            end
        end

        function delete(app)
            delete(app.UIFigure);
        end
    end
end