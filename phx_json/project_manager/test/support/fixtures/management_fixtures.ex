defmodule ProjectManager.ManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ProjectManager.Management` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> ProjectManager.Management.create_project()

    project
  end

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{

      })
      |> ProjectManager.Management.create_document()

    document
  end
end
