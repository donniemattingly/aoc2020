use rustler::ListIterator;
use rustler::{Encoder, Env, Error, Term};

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
        ("test_timestamp", 3, test_timestamp)
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
