defmodule Weather.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> process
  end
  
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])
    
    case parse do
      { [help: true], _, _ }    -> :help
      { _, [airport_code], _ }  -> airport_code
      _                         -> :help
    end
  end
    
  def process(:help) do
    IO.puts """
    usage: weather <airport code>
    """
  end
  
  def process(airport_code) do
    Weather.NOAAObservations.fetch(airport_code)
    |> IO.inspect
  end
end