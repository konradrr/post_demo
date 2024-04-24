defmodule PostDemoWeb.PostLive do
  @moduledoc false
  use PostDemoWeb, :live_view

  alias PostDemo.Posts
  alias PostDemo.Posts.Comment
  alias PostDemo.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Posts.subscribe()
    end

    socket
    |> assign_post()
    |> assign_comments()
    |> assign_comment_form()
    |> assign_title()
    |> ok()
  end

  defp assign_post(socket) do
    assign(socket, :post, List.last(Posts.list_posts()))
  end

  def assign_comments(%{assigns: %{post: post}} = socket) do
    assign(socket, :comments, Posts.get_comments_by_post(post))
  end

  def assign_comment_form(socket) do
    assign(socket, :comment_form, to_form(Posts.change_comment(%Comment{})))
  end

  defp assign_title(socket) do
    assign(socket, :page_title, socket.assigns.post.title)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.post post={@post} />
    <.comments comments={@comments} comment_form={@comment_form} />
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
  attr :comment_form, Phoenix.HTML.Form, required: true

  def comments(assigns) do
    ~H"""
    <section>
      <.h2>Comments</.h2>

      <.simple_form
        id="comment_form"
        for={@comment_form}
        phx-change="validate_comment"
        phx-submit="post_comment"
      >
        <.input field={@comment_form[:author]} label={gettext("Author")} phx-debounce="200" />
        <.input
          field={@comment_form[:body]}
          type="textarea"
          label={gettext("Comment")}
          phx-debounce="200"
        />

        <.button><%= gettext("Post Comment") %></.button>
      </.simple_form>

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

  @impl true
  def handle_event("validate_comment", %{"comment" => params}, socket) do
    comment_form = %Comment{} |> Posts.change_comment(params) |> Map.put(:action, :validate) |> to_form()

    socket
    |> assign(:comment_form, comment_form)
    |> noreply()
  end

  @impl true
  def handle_event("post_comment", %{"comment" => params}, socket) do
    params = Map.put(params, "post_id", socket.assigns.post.id)

    case Posts.create_comment(params) do
      {:ok, _comment} ->
        socket
        |> assign_comment_form()
        |> put_flash(:info, gettext("Posted a comment!"))
        |> noreply()

      {:error, _changeset} ->
        socket
        |> put_flash(:error, gettext("Something went wrong..."))
        |> noreply()
    end
  end

  @impl true
  def handle_info({:comment_created, comment}, socket) do
    socket
    # efficient, but might be brittle
    |> update(:comments, fn comments -> [comment | comments] end)
    |> noreply()
  end
end
