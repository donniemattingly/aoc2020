defmodule Utils.Fast do
  use Rustler, otp_app: :adventofcode, crate: :fastutils

  def test_timestamp(_arg1, _arg2, _arg3), do: :erlang.nif_error(:nif_not_loaded)
  def get_loop_size(_arg1), do: :erlang.nif_error(:nif_not_loaded)
  def transform(_arg1, _arg2), do: :erlang.nif_error(:nif_not_loaded)
end
