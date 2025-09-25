use zellij_tile::prelude::*;
use std::collections::BTreeMap;
use chrono::Local;

register_plugin!(State);

struct TaskbarItem {
    pane_id: PaneId,
    title: String,
    rect: Option<(usize, usize, usize)>, // x, width, row
}

#[derive(Default)]
pub struct State {
    items: Vec<TaskbarItem>,
    active_tab: usize,
    last_rows: usize,
}

impl ZellijPlugin for State {
    fn load(&mut self, _configuration: BTreeMap<String, String>) {
        subscribe(&[
            EventType::PaneUpdate,
            EventType::TabUpdate,
            EventType::Mouse,
            EventType::Timer,
        ]);
        set_selectable(false);
        request_permission(&[
            PermissionType::ReadApplicationState,
            PermissionType::ChangeApplicationState,
            PermissionType::OpenTerminalsOrPlugins,
        ]);
        set_timeout(1.0);
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::Timer(..) => {
                set_timeout(1.0);
                true
            }
            Event::TabUpdate(tabs) => {
                if let Some(active) = tabs.iter().find(|t| t.active) {
                    self.active_tab = active.position;
                }
                false
            }
            Event::PaneUpdate(pane_manifest) => {
                let mut new_items: Vec<TaskbarItem> = Vec::new();
                if let Some(panes) = pane_manifest.panes.get(&self.active_tab) {
                    for p in panes {
                        let pane_id = if p.is_plugin {
                            PaneId::Plugin(p.id)
                        } else {
                            PaneId::Terminal(p.id)
                        };
                        let title = p.title.clone();
                        new_items.push(TaskbarItem { pane_id, title, rect: None });
                    }
                }
                self.items = new_items;
                true
            }
            Event::Mouse(mouse) => {
                match mouse {
                    Mouse::LeftClick(row, col) => {
                        if row as usize == self.last_rows.saturating_sub(1) {
                            for item in &self.items {
                                if let Some((x, w, r)) = item.rect {
                                    if r == row as usize && col >= x && col < x + w {
                                        focus_pane_with_id(item.pane_id, true);
                                        return false;
                                    }
                                }
                            }
                        }
                    }
                    _ => {}
                }
                false
            }
            _ => false,
        }
    }

    fn render(&mut self, rows: usize, cols: usize) {
        self.last_rows = rows;
        let clock = Local::now().format("%H:%M").to_string();
        let row = rows.saturating_sub(1);
        let mut x = 0usize;

        // clear line
        let clear = " ".repeat(cols);
        print_text_with_coordinates(Text::new(clear), 0, row, None, None);

        // app button (click to spawn new floating terminal)
        let app_label = " TuiTop ";
        print_text_with_coordinates(Text::new(app_label), x, row, None, None);
        let app_end = x + app_label.len();
        // store a pseudo-rect in first slot to open terminal if clicked
        // we piggyback on rects by inserting a synthetic item with PaneId::Terminal(0) unused
        // (click handling below checks real rectangles first)

        x = app_end + 1;

        for item in &mut self.items {
            let title = if item.title.is_empty() { "shell".to_string() } else { item.title.clone() };
            let text = format!(" [{}]", title);
            print_text_with_coordinates(Text::new(&text), x, row, None, None);
            item.rect = Some((x, text.len(), row));
            x += text.len() + 1;
            if x + 8 >= cols { break; }
        }

        // right-aligned clock
        let clock_x = cols.saturating_sub(clock.len() + 1);
        print_text_with_coordinates(Text::new(format!(" {}", clock)), clock_x, row, None, None);
    }
}

pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
