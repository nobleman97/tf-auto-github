resource "github_repository" "this" {
  name        = "auto-created-repo"
  description = "Repo automatically created by Terraform"
  visibility = "public"

  auto_init  = true 
}

resource "github_repository_environment" "this" {
  for_each = var.environments
  
  environment         = each.value.name
  repository          = github_repository.this.name
  prevent_self_review = true

  reviewers {
    users = [data.github_user.current.id]
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_branch" "develop" {
  repository = github_repository.this.name
  branch     = "develop"
}

resource "github_repository_file" "this" {
  for_each = var.environments

  repository          = github_repository.this.name
  branch              = "main"
  file                = ".github/workflows/build-deploy-${each.value.name}.yaml"
  content             = file("workflow.yaml")
  commit_message      = "Managed by Terraform"
  commit_author       = "David Nobleman"
  commit_email        = "davidstone097@gmail.com"
  overwrite_on_create = true

  depends_on = [ github_branch.develop ]
}

