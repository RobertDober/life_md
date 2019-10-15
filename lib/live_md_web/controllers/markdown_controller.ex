defmodule LiveMdWeb.MarkdownController do
  use LiveMdWeb, :controller

  def index(conn, _params) do
    with {:ok, files} <- File.ls(config[:markdown_dir]) do
      md_files =
        files
        |> Enum.filter(&Regex.match?(~r{\.md\z}i, &1))
        |> Enum.map(&[&1, ~s{<a href="#{Routes.markdown_path(conn, :show, &1)}">Show</a>}])
        
      {:ok, table_data, []} = Lab42.Html.gen_table(
        [["Markdown doc", "Action"]|md_files]
      )
    
      conn
      |> put_layout("markdown.html")
      |> render("index.html", table: {:safe, table_data})
    end
  end

  def show(conn, %{"id" => file_name}) do
    path = Path.join([config[:markdown_dir], file_name])
    html = File.read!(path) |> Earmark.as_html! |> IO.inspect

    conn
    |> put_layout("markdown.html")
    |> render("show.html", html: {:safe, html})
  end


  defp config do
    Application.get_env(:live_md, LiveMdWeb.Endpoint)
  end
end
