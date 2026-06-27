check_git_signature() {
  git verify-commit HEAD >/dev/null 2>&1 || {
    error "Unsigned commit detected"
    exit 1
  }
}