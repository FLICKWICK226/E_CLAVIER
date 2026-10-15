use eframe::egui;

#[derive(PartialEq, Clone, Copy)]
enum Language {
    Moore = 1,
    Dioula = 2,
    Fulfulde = 3,
}

struct ClavierApp {
    buffer: Vec<u16>,
    lang: Language,
    is_shift: bool,
    status_msg: String,
}

impl Default for ClavierApp {
    fn default() -> Self {
        Self {
            buffer: Vec::with_capacity(1024),
            lang: Language::Moore,
            is_shift: false,
            status_msg: "Pret - Clavier Virtuel & Physique actif".to_string(),
        }
    }
}

impl ClavierApp {
    fn get_active_keys(&self) -> [u16; 5] {
        match (self.lang, self.is_shift) {
            (Language::Moore, false) => [0x025B, 0x0269, 0x028B, 0x0027, 0],
            (Language::Moore, true)  => [0x0190, 0x0196, 0x01B2, 0x0027, 0],
            (Language::Dioula, false) => [0x025B, 0x0254, 0x0272, 0x014B, 0],
            (Language::Dioula, true)  => [0x0190, 0x0186, 0x019D, 0x014A, 0],
            (Language::Fulfulde, false) => [0x0253, 0x0257, 0x01B4, 0x0272, 0x014B],
            (Language::Fulfulde, true)  => [0x0181, 0x018A, 0x01B3, 0x019D, 0x014A],
        }
    }

    fn is_vowel(code: u16) -> bool {
        matches!(code, 97 | 101 | 105 | 111 | 117 | 603 | 617 | 651 | 596 | 65 | 69 | 73 | 79 | 85 | 400 | 406 | 434 | 390)
    }

    fn is_diacritic(code: u16) -> bool {
        (0x0300..=0x036F).contains(&code)
    }

    fn insert_char(&mut self, code_in: u16) {
        if self.buffer.len() >= 1024 || code_in == 0 { return; }
        if Self::is_diacritic(code_in) {
            let len = self.buffer.len();
            if len == 0 { self.status_msg = "Bloque : Diacritique en debut de texte.".into(); return; }
            let last = self.buffer[len - 1];
            if last == code_in { return; }
            if Self::is_diacritic(last) {
                if len < 2 || !Self::is_vowel(self.buffer[len - 2]) {
                    self.status_msg = "Bloque : Max 2 diacritiques par voyelle.".into(); return;
                }
            } else if !Self::is_vowel(last) {
                self.status_msg = "Bloque : Le diacritique doit suivre une voyelle.".into(); return;
            }
        }
        self.buffer.push(code_in);
        self.status_msg = format!("Code points : {}", self.buffer.len());
    }

    fn backspace(&mut self) {
        while let Some(&last) = self.buffer.last() {
            if Self::is_diacritic(last) { self.buffer.pop(); } else { break; }
        }
        self.buffer.pop();
        self.status_msg = format!("Code points : {}", self.buffer.len());
    }

    fn current_text(&self) -> String {
        String::from_utf16_lossy(&self.buffer)
    }
}

impl eframe::App for ClavierApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        // Handle physical keyboard shortcuts if needed
        ctx.input(|i| {
            if i.key_pressed(egui::Key::Backspace) {
                self.backspace();
            }
        });

        egui::CentralPanel::default().show(ctx, |ui| {
            ui.heading("E_CLAVIER - Clavier Multilingue (EPO Ouaga)");
            ui.horizontal(|ui| {
                ui.label("Langue :");
                ui.selectable_value(&mut self.lang, Language::Moore, "Mooré");
                ui.selectable_value(&mut self.lang, Language::Dioula, "Dioula");
                ui.selectable_value(&mut self.lang, Language::Fulfulde, "Fulfuldé");
                ui.separator();
                ui.checkbox(&mut self.is_shift, "MAJ (Shift)");
            });

            ui.add_space(8.0);
            ui.label("Zone de texte :");
            let mut text = self.current_text();
            ui.add(egui::TextEdit::multiline(&mut text).desired_rows(4).font(egui::TextStyle::Heading));

            ui.add_space(10.0);
            ui.horizontal(|ui| {
                if ui.button("Copier le texte").clicked() {
                    ctx.copy_text(text.clone());
                    self.status_msg = "Texte copie dans le presse-papiers !".into();
                }
                if ui.button("Tout effacer").clicked() {
                    self.buffer.clear();
                    self.status_msg = "Zone effacee.".into();
                }
            });

            ui.add_space(10.0);
            ui.separator();
            ui.label("Pave tactile des caracteres speciaux (ANB) & Diacritiques :");

            ui.horizontal(|ui| {
                let keys = self.get_active_keys();
                for &k in &keys {
                    if k != 0 {
                        let s = format!("{}", char::from_u32(k as u32).unwrap_or('?'));
                        if ui.button(s).clicked() {
                            self.insert_char(k);
                        }
                    }
                }
                ui.separator();
                // Diacritics
                let diacritics = [("Ton Bas `", 768), ("Ton Haut ´", 769), ("Circonflexe ^", 770), ("Nasal ~", 771)];
                for (label, code) in diacritics {
                    if ui.button(label).clicked() {
                        self.insert_char(code);
                    }
                }
            });

            ui.add_space(10.0);
            ui.horizontal(|ui| {
                if ui.button("Espace").clicked() { self.insert_char(32); }
                if ui.button("Entree").clicked() { self.insert_char(10); }
                if ui.button("<- Retour (Cluster)").clicked() { self.backspace(); }
            });

            ui.add_space(10.0);
            ui.label(egui::RichText::new(&self.status_msg).color(egui::Color32::DARK_GRAY));
        });
    }
}

fn main() -> Result<(), eframe::Error> {
    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default().with_inner_size([800.0, 500.0]),
        ..Default::default()
    };
    eframe::run_native("E_CLAVIER GUI", options, Box::new(|_cc| Box::<ClavierApp>::default()))
}
