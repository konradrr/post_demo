defmodule PostDemoWeb.PostLive do
  @moduledoc false
  use PostDemoWeb, :live_view

  alias PostDemo.Posts
  alias PostDemo.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign_post()
    |> assign_title()
    |> ok()
  end

  defp assign_post(socket) do
    assign(socket, :post, hd(Posts.list_posts()))
  end

  defp assign_title(socket) do
    assign(socket, :page_title, socket.assigns.post.title)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.post post={@post} />
    <.comments />
    """
  end

  attr :post, Post, required: true

  def post(assigns) do
    ~H"""
    <section>
      <h1><%= @post.title %></h1>
      <p><%= @post.body %></p>
    </section>
    """
  end

  def comments(assigns) do
    ~H"""
    <section>
      <h2>Comments</h2>
    </section>
    """
  end
end
