defmodule Weather.NOAAObservations do
  require Record
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  @noaa_url Application.get_env(:weather, :noaa_url)
  
  def fetch(airport_code) do
    observation_url(airport_code)
    |> HTTPoison.get
    |> handle_response
  end
  
  def observation_url(airport_code) do
    "#{@noaa_url}/#{airport_code}.xml"
  end
  
  def handle_response(%{status_code: 200, body: body}) do
    { xml_document, _remaining } = :xmerl_scan.string(to_char_list(body))
    #{:ok, xml_document}
    [location|_t] = :xmerl_xpath.string('//location[1]/text()',  xml_document)
    [weather|_t] = :xmerl_xpath.string('//weather[1]/text()',  xml_document)
    [temperature|_t] = :xmerl_xpath.string('//temperature_string[1]/text()',  xml_document)
    {:ok, xmlText(location, :value), xmlText(weather, :value), xmlText(temperature, :value)}
  end
    
  
  def handle_response(%{status_code: ___, body: body}), do: {:error, body}
end