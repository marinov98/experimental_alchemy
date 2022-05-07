alias ProjectManager.Repo
alias ProjectManager.Management.Project

Repo.insert!(%Project{
  title: "Super cool project",
  description: "This project is the best project ever"
})

Repo.insert!(%Project{
  title: "Super cool project 2",
  description: "This project is the best project ever 2"
})

Repo.insert!(%Project{
  title: "A project",
  description: "This is a project"
})
