defmodule Magnetissimo.Crawler do
  def crawl(url, root, previously_crawled) do
    cond do
      String.starts_with?(url, "magnet") ->
        create_torrent(url)
      true ->
        cond do
          url in previously_crawled ->
            IO.puts "Duplicate url: #{url}"
          true ->
            IO.puts "Crawling: #{url}"
            Process.sleep(1000)
            case HTTPoison.get(url) do
              {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                body
                |> Floki.find("a")
                |> Floki.attribute("href")
                |> Enum.each(fn(href) ->
                  cond do
                    String.starts_with?(href, "/")  ->
                      crawl_url = root <> href
                      crawl(crawl_url, root, [url | previously_crawled])
                    true ->
                  end
                end)
              {:ok, %HTTPoison.Response{status_code: 404}} ->
                IO.puts "Not found :("
              _ ->
                IO.puts "Who knows lol"
            end
        end
    end
  end

  def create_torrent(url) do
    IO.puts "Creating Torrent for: #{url}"
    # Create Torrent object and save to database.
  end
end