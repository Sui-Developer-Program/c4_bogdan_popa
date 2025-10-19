module guestbook::guestbook;

use std::string::String;

const MAX_MESSAGE_LENGTH: u64 = 280;

const EInvalidLength: u64 = 0;

public struct Message has store {
    sender: address,
    content: String,
}

public struct GuestBook has key, store {
    id: UID,
    messages: vector<Message>,
    no_of_messages: u64,
}

fun init(ctx: &mut TxContext) {
    let guestBook = GuestBook {
        id: object::new(ctx),
        messages: vector::empty<Message>(),
        no_of_messages: 0,
    };

    sui::transfer::share_object(guestBook);
}

public fun post_message(guestBook: &mut GuestBook, message: Message) {
    vector::push_back(&mut guestBook.messages, message);
    guestBook.no_of_messages = guestBook.no_of_messages + 1;
}

public fun create_message(message: String, ctx: &mut TxContext): Message {
    assert!(std::string::length(&message) <= MAX_MESSAGE_LENGTH, EInvalidLength);

    Message {
        sender: ctx.sender(),
        content: message
    }
}