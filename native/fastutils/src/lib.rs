use rustler::ListIterator;
use rustler::{Encoder, Env, Error, Term};
use mod_exp::mod_exp;

mod atoms {
    rustler::rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Utils.Fast",
    [
        ("test_timestamp", 3, test_timestamp),
        ("get_loop_size", 1, get_loop_size),
        ("transform", 2, do_transform)
    ],
    None
}

fn test_timestamp<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let timestamp: i64 = args[0].decode()?;
    let args_iterator: ListIterator<'a> = args[1].into_list_iterator()?;
    let idx_iterator: ListIterator<'a> = args[2].into_list_iterator()?;
    for (t1, t2) in args_iterator.zip(idx_iterator) {
        let bus_id: i64 = t1.decode()?;
        let offset: i64 = t2.decode()?;

        if (timestamp + offset) & bus_id != 0 {
            return Ok((atoms::ok(), false).encode(env));
        }
    }

    Ok((atoms::ok(), true).encode(env))
}

fn get_loop_size<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let public_key: i64 = args[0].decode()?;
    let mut subject: i64 = 1;
    let mut size: i64 = 1;

    while !(subject == public_key) {
        subject = mod_exp(7, size, 20201227);
        size = size + 1;
    }

    Ok((atoms::ok(), size - 1).encode(env))
}

fn do_transform<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let subject: i64 = args[0].decode()?;
    let size: i64 = args[1].decode()?;
    let converted = mod_exp(subject, size, 20201227);
    Ok((atoms::ok(), converted).encode(env))
}
