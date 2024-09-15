src/core/counter.rs
struct Counter {
    initial_counter: i32,
}

impl Component for Counter {
    fn render(&self) -> VNode {
        let counter = use_state(|| self.initial_counter);

        h!(div).build((
            h!(p).build(("Counter: ", *counter.value())),
            h!(button).on_click(&Callback::new({
                clones!(mut counter);
                move |_| counter.set(|c| c + 1)
            })).build("Increment"),
        ))
    }
  }
