{
  # Coding agent CLIs and their permission/provider settings
  flake.modules.homeManager.ai-agents =
    { lib, ... }:
    {
      programs = {
        pi-coding-agent = {
          enable = true;
        };

        opencode = {
          enable = true;
          # package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings = {
            permission = {
              edit = "ask";
              webfetch = "ask";
              bash = {
                "*" = "ask";
                "terraform *" = "deny";
                "terraform fmt *" = "allow";
                "terraform plan *" = "allow";
                "terraform validate" = "allow";
                "rg *" = "allow";
                "fd *" = "allow";
                "fd *-x*" = "ask";
                "fd *--exec*" = "ask";
                "fd *-X*" = "ask";
                "fd *--exec-batch*" = "ask";
                "find *" = "allow";
                "find *-exec*" = "ask";
                "find *--exec*" = "ask";
                "find *-execdir*" = "ask";
                "find *--execdir*" = "ask";
                "sed *" = "allow";
                "grep *" = "allow";
                "jq *" = "allow";
                "git diff *" = "allow";
                "git status *" = "allow";
                "git log *" = "allow";
                "git grep *" = "allow";
                "git show *" = "allow";
                "git branch" = "allow";
                "git branch --show-current" = "allow";
                "git branch -a" = "allow";
                "git branch --all" = "allow";
                "git merge-base *" = "allow";
                "git blame" = "allow";
                "git status" = "allow";
                "git blame *" = "allow";
                "git describe *" = "allow";
                "git rev-parse *" = "allow";
                "git reflog" = "allow";
                "git reflog show" = "allow";
                "git reflog show *" = "allow";
                "git reflog list" = "allow";
                "git reflog exists *" = "allow";
                "git remote" = "allow";
                "git remote -v" = "allow";
                "git remote get-url *" = "allow";
                "git remote show *" = "allow";
                "git ls-files *" = "allow";
                "git ls-tree *" = "allow";
                "git ls-remote *" = "allow";
                "git show-ref *" = "allow";
                "git for-each-ref *" = "allow";
                "git check-ignore *" = "allow";
                "git check-attr *" = "allow";
                "git shortlog *" = "allow";
                "git tag --list" = "allow";
                "git tag --list *" = "allow";
                "git tag -l" = "allow";
                "git tag -l *" = "allow";
                "git stash list" = "allow";
                "git stash show" = "allow";
                "git stash show *" = "allow";
                "git config --list" = "allow";
                "git config --get *" = "allow";
                "git config --get-all *" = "allow";
                "git config --get-regexp *" = "allow";
                "git count-objects *" = "allow";
                "git fsck *" = "allow";
                "git worktree list" = "allow";
                "gh pr view *" = "allow";
                "gh pr diff *" = "allow";
                "gh auth status" = "allow";
                "gh status" = "allow";
                "gh repo list *" = "allow";
                "gh repo view *" = "allow";
                "gh repo status *" = "allow";
                "gh pr list *" = "allow";
                "gh pr checks *" = "allow";
                "gh pr status" = "allow";
                "gh issue list *" = "allow";
                "gh issue view *" = "allow";
                "gh issue status" = "allow";
                "gh release list *" = "allow";
                "gh release view *" = "allow";
                "gh run list *" = "allow";
                "gh run view *" = "allow";
                "gh run watch *" = "allow";
                "gh workflow list" = "allow";
                "gh workflow view *" = "allow";
                "gh search *" = "allow";
                "gh gist list" = "allow";
                "gh gist view *" = "allow";
                "gh project list" = "allow";
                "gh project view *" = "allow";
                "gh project item-list *" = "allow";
                "gh ruleset list *" = "allow";
                "gh ruleset view *" = "allow";
                "gh extension list" = "allow";
                "gh alias list" = "allow";
                "jj log *" = "allow";
                "jj diff *" = "allow";
                "jj st *" = "allow";
                "jj status *" = "allow";
                "jj show *" = "allow";
                "jj status" = "allow";
                "jj st" = "allow";
                "jj diff" = "allow";
                "jj log" = "allow";
                "jj show" = "allow";
                "jj root" = "allow";
                "jj files" = "allow";
                "jj file list *" = "allow";
                "jj file show *" = "allow";
                "jj interdiff *" = "allow";
                "jj obslog *" = "allow";
                "jj evolog *" = "allow";
                "jj op log *" = "allow";
                "jj op show *" = "allow";
                "jj workspace list" = "allow";
                "jj bookmark list *" = "allow";
                "jj tag list *" = "allow";
                "jj config list" = "allow";
                "jj config get *" = "allow";
                "jj config path" = "allow";
                "jj git remote list *" = "allow";
                "git reflog write *" = "ask";
                "git reflog delete *" = "ask";
                "git reflog drop *" = "ask";
                "git reflog expire *" = "ask";
                "git fsck *--lost-found*" = "ask";
                "git diff *--output*" = "ask";
                "git diff -o*" = "ask";
                "git diff * -o*" = "ask";
                "git log *--output*" = "ask";
                "git log -o*" = "ask";
                "git log * -o*" = "ask";
                "git show *--output*" = "ask";
                "git show -o*" = "ask";
                "git show * -o*" = "ask";
                "git reflog *--output*" = "ask";
                "git reflog show -o*" = "ask";
                "git reflog show * -o*" = "ask";
                "jj op restore *" = "ask";
                "jj op abandon *" = "ask";
                "jj op revert *" = "ask";
                "jj op integrate *" = "ask";
                "jj bookmark advance *" = "ask";
                "jj bookmark create *" = "ask";
                "jj bookmark delete *" = "ask";
                "jj bookmark forget *" = "ask";
                "jj bookmark move *" = "ask";
                "jj bookmark rename *" = "ask";
                "jj bookmark set *" = "ask";
                "jj bookmark track *" = "ask";
                "jj bookmark untrack *" = "ask";
                "jj config edit *" = "ask";
                "jj config gc *" = "ask";
                "jj config set *" = "ask";
                "jj config unset *" = "ask";
                "jj git fetch *" = "ask";
                "jj git push *" = "ask";
                "jj git clone *" = "ask";
                "jj git import *" = "ask";
                "jj git export *" = "ask";
                "gh api *" = "ask";
                "aws sts get-caller-identity" = "allow";
                "aws configure list" = "allow";
                "aws cloudwatch describe-*" = "allow";
                "aws cloudwatch get-metric-data *" = "allow";
                "aws cloudwatch get-metric-statistics *" = "allow";
                "aws cloudwatch list-metrics *" = "allow";
                "aws cloudwatch get-dashboard *" = "allow";
                "aws cloudwatch list-dashboards *" = "allow";
                "aws cloudwatch get-metric-widget-image *" = "allow";
                "aws logs describe-*" = "allow";
                "aws logs get-log-events *" = "allow";
                "aws logs get-log-group-fields *" = "allow";
                "aws logs get-query-results *" = "allow";
                "aws logs filter-log-events *" = "allow";
                "aws logs tail *" = "allow";
                "aws dynamodb list-*" = "allow";
                "aws dynamodb describe-*" = "allow";
                "aws dynamodb get-item *" = "allow";
                "aws dynamodb batch-get-item *" = "allow";
                "aws dynamodb query *" = "allow";
                "aws dynamodb scan *" = "allow";
                "aws lambda list-*" = "allow";
                "aws lambda get-*" = "allow";
                "aws ecs list-*" = "allow";
                "aws ecs describe-*" = "allow";
                "aws s3 ls" = "allow";
                "aws s3 ls *" = "allow";
                "aws s3api list-*" = "allow";
                "aws s3api head-bucket *" = "allow";
                "aws s3api head-object *" = "allow";
                "aws s3api get-bucket-*" = "allow";
                "aws s3api get-object-acl *" = "allow";
                "aws s3api get-object-attributes *" = "allow";
                "aws s3api get-object-tagging *" = "allow";
                "aws ec2 describe-*" = "allow";
                "aws rds describe-*" = "allow";
                "aws eks list-*" = "allow";
                "aws eks describe-*" = "allow";
                "aws ecr list-*" = "allow";
                "aws ecr describe-*" = "allow";
                "aws ecr batch-get-image *" = "allow";
                "aws cloudtrail describe-*" = "allow";
                "aws cloudtrail get-*" = "allow";
                "aws cloudtrail lookup-events *" = "allow";
                "aws xray get-*" = "allow";
                "aws xray list-*" = "allow";
                "aws xray batch-get-*" = "allow";
                "aws iam get-*" = "allow";
                "aws iam list-*" = "allow";
                "aws logs start-query *" = "ask";
                "aws logs stop-query *" = "ask";
                "aws lambda invoke *" = "ask";
                "aws ecs execute-command *" = "ask";
                "aws ecs run-task *" = "ask";
                "aws ecs stop-task *" = "ask";
                "aws s3 cp *" = "ask";
                "aws s3 sync *" = "ask";
                "aws s3api get-object *" = "ask";
                "aws dynamodb put-item *" = "ask";
                "aws dynamodb update-item *" = "ask";
                "aws dynamodb delete-item *" = "ask";
                "aws dynamodb batch-write-item *" = "ask";
                "aws dynamodb create-table *" = "ask";
                "aws dynamodb delete-table *" = "ask";
                "aws dynamodb update-table *" = "ask";
                "aws dynamodb export-table-to-point-in-time *" = "ask";
                "aws dynamodb restore-table-to-point-in-time *" = "ask";
                "aws dynamodb execute-statement *" = "ask";
                "aws dynamodb batch-execute-statement *" = "ask";
                "aws ssm get-parameter *" = "ask";
                "aws ssm get-parameters *" = "ask";
                "aws ssm get-parameters-by-path *" = "ask";
                "aws ssm send-command *" = "ask";
                "aws ssm start-session *" = "ask";
                "aws secretsmanager get-secret-value *" = "ask";
                "aws ecr get-login-password *" = "ask";
                "aws eks get-token *" = "ask";
                "aws eks update-kubeconfig *" = "ask";
                "aws sts assume-role *" = "ask";
                "aws sts get-session-token *" = "ask";
                "aws sts get-federation-token *" = "ask";
                "aws configure set *" = "ask";
                "date *" = "allow";
                "ls *" = "allow";
                "echo *" = "allow";
                "cat *" = "allow";
                "head *" = "allow";
                "tail *" = "allow";
                "stat *" = "allow";
                "sort *" = "allow";
                "file *" = "allow";
                "realpath *" = "allow";
                "readlink *" = "allow";
                "du *" = "allow";
                "wc *" = "allow";
                "diff *" = "allow";
                "mkdir *" = "allow";
                "pwd" = "allow";
                "npm test *" = "allow";
                "npm run test *" = "allow";
                "npx eslint *" = "allow";
                "npm run lint *" = "allow";
                "npm run build *" = "allow";
                "npm run build" = "allow";
                "npm run verify" = "allow";
                "npm run verify *" = "allow";
                "npm run check *" = "allow";
                "npm run format-check *" = "allow";
                "npm run typecheck *" = "allow";
                "just check *" = "allow";
                "just test *" = "allow";
                "just test-deterministic *" = "allow";
                "just lint *" = "allow";
                "just format *" = "allow";
                "just typecheck" = "allow";
                "pnpm check *" = "allow";
                "pnpm test *" = "allow";
                "pnpm lint *" = "allow";
                "pnpm format *" = "allow";
                "pnpm format-check *" = "allow";
                "pnpm typecheck *" = "allow";
                "pnpm run check *" = "allow";
                "pnpm run test *" = "allow";
                "pnpm run lint *" = "allow";
                "pnpm run format *" = "allow";
                "pnpm run format-check *" = "allow";
                "pnpm run typecheck *" = "allow";
                "pnpm run build" = "allow";
                "pnpm run verify" = "allow";
                "pnpm run verify *" = "allow";
                "pnpm --prefix * run *" = "allow";
                "npm --prefix * run *" = "allow";
                "uv run test" = "allow";
                "uv run pytest *" = "allow";
                "uv run ruff format *" = "allow";
                "uv run ruff check *" = "allow";
                "lk --version" = "allow";
                "lk --help" = "allow";
                "lk docs *" = "allow";
              };
            };
            agent = {
              chat = {
                mode = "primary";
                description = "For chats not directly related to current files";
                prompt = ''
                  You are a chat-based assistant. You should not use the context of
                  the current system's files unless explicitly asked to.
                '';
                tools = {
                  edit = false;
                };
                permission = {
                  "sed *--in-place*" = "deny";
                  "sed *-i*" = "deny";
                };
                color = "#b8bb26";
              };
              auto = {
                mode = "primary";
                tools = {
                  edit = true;
                };
                color = "#fe8019";
              };
              plan = {
                mode = "primary";
                tools = {
                  edit = false;
                };
                color = "#8ec07c";
                permission = {
                  "sed *--in-place*" = "deny";
                  "sed *-i*" = "deny";
                };
              };
            };
            provider = {
              openai = {
                models =
                  lib.genAttrs
                    [
                      "gpt-5"
                      "gpt-5-mini"
                      "gpt-5-nano"
                      "gpt-5-codex"
                      "gpt-5.1"
                      "gpt-5.1-codex"
                      "gpt-5.1-codex-mini"
                      "gpt-5.1-codex-max"
                      "gpt-5.2"
                      "gpt-5.2-codex"
                      "gpt-5.2-pro"
                    ]
                    (_: {
                      options = {
                        store = false;
                      };
                    });
              };
              amazon-bedrock = {
                options = {
                  profile = "default";
                  region = "us-east-1";
                };
              };
            };
          };
        };

        antigravity-cli.enable = true;
      };
    };
}
