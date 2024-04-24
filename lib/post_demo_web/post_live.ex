defmodule PostDemoWeb.PostLive do
  @moduledoc false
  use PostDemoWeb, :live_view

  alias PostDemo.Posts
  alias PostDemo.Posts.Comment
  alias PostDemo.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign_post()
    |> assign_comments()
    |> assign_title()
    |> ok()
  end

  defp assign_post(socket) do
    assign(socket, :post, List.last(Posts.list_posts()))
  end

  def assign_comments(%{assigns: %{post: post}} = socket) do
    assign(socket, :comments, Posts.get_comments_by_post(post))
  end

  defp assign_title(socket) do
    assign(socket, :page_title, socket.assigns.post.title)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.post post={@post} />
    <.comments comments={@comments} />
    """
  end

  attr :post, Post, required: true

  def post(assigns) do
    ~H"""
    <section class="mb-10">
      <.h1><%= @post.title %></.h1>
      <.p><%= @post.body %></.p>
    </section>
    """
  end

  attr :comments, :list, required: true

  def comments(assigns) do
    ~H"""
    <section>
      <.h2>Comments</.h2>

      <.comment :for={comment <- @comments} comment={comment} />
    </section>
    """
  end

  attr :comment, Comment, required: true

  def comment(assigns) do
    ~H"""
    <div class="p-6 pb-4 text-base bg-white border-b border-gray-200 dark:border-gray-700 dark:bg-gray-900">
      <div class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold">
        <%= @comment.author %>
      </div>
      <.p class="text-gray-500 dark:text-gray-400"><%= @comment.body %></.p>
    </div>
    """
  end
end
