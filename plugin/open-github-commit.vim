" To make sure plugin is loaded only once,
" and to allow users to disable the plugin
" with a global conf.
if exists("g:do_not_load_open_github_commit")
  finish
endif
let g:do_not_load_open_github_commit = 1

" If this command doesn't exist, create one.
if !exists(":OpenGithubCommit")
  command OpenGithubCommit  :call s:OpenGithubCommit()
endif

" If this command doesn't exist, create one.
if !exists(":OpenGithubPR")
  command OpenGithubPR  :call s:OpenGithubPR()
endif

" Opens last commit of current line in the browser
function! s:OpenGithubCommit()
  let commit_sha = s:CommitShaForCurrentLine()
  if(commit_sha =~ "0\\{40}")
    echohl WarningMsg | echomsg "This line is not on git yet!" | echohl None
  else
    call s:OpenBrowser(s:GetCommitUrl(commit_sha))
  endif
endfunction

" Opens PR containing last commit of current line in the browser
function! s:OpenGithubPR()
  let commit_sha = s:CommitShaForCurrentLine()
  if(commit_sha =~ "0\\{40}")
    echohl WarningMsg | echomsg "This line is not on git yet!" | echohl None
  else
    call s:OpenBrowser(s:GetPRUrl(commit_sha))
  endif
endfunction

function! s:CommitShaForCurrentLine()
  let linenumber = line('.')
  let path = expand('%:p')

  let cmd = 'git blame -L'.linenumber.','.linenumber.' --porcelain '.path
  let blame_text = system(cmd)

  return matchstr(blame_text, '\w\+')
endfunction

function! s:GetCommitUrl(commit_sha)
  let cmd = 'git ls-remote --get-url'
  let remote = system(cmd)
  let git_to_http = substitute(remote, "git@", "http://", "")
  let colon_to_slash = substitute(git_to_http, "github\\.com:", "github.com/", "")
  let url = substitute(colon_to_slash, "\\.git\\n", "", "")
  let commit_url = '' . url . "/commit/" . a:commit_sha
  return commit_url
endfunction

function! s:GetPRUrl(commit_sha)
  let merged_into_branch = "HEAD"
  let cmd = 'git ls-remote --get-url'
  let remote = system(cmd)
  let git_to_http = substitute(remote, "git@", "http://", "")
  let colon_to_slash = substitute(git_to_http, "github\\.com:", "github.com/", "")
  let url = substitute(colon_to_slash, "\\.git\\n", "", "")
  let pr_no_output = system("git log --merges --ancestry-path --oneline " .
        \  a:commit_sha . ".." . merged_into_branch . "| " .
        \ "grep 'pull request' | tail -n1 | awk '{print $5}' | " .
        \ "cut -c2-")
  let pr_no = substitute(pr_no_output, "\n", "", "")
  let pr_url = '' . url . "/pull/" . pr_no
  return pr_url
endfunction

" From
" https://github.com/mmozuras/vim-github-comment/blob/306f49b0d0b558a9e476d49304ff371cc13f96eb/plugin/github-comment.vim#L174-L190
function! s:OpenBrowser(url)
  if has('win32') || has('win64')
    let cmd = '!start rundll32 url.dll,FileProtocolHandler '.shellescape(a:url)
    silent! exec cmd
  elseif has('mac') || has('macunix') || has('gui_macvim')
    let cmd = 'open '.shellescape(a:url)
    call system(cmd)
  elseif executable('xdg-open')
    let cmd = 'xdg-open '.shellescape(a:url)
    call system(cmd)
  elseif executable('firefox')
    let cmd = 'firefox '.shellescape(a:url).' &'
    call system(cmd)
  else
    echohl WarningMsg | echomsg "That's weird. It seems that you don't have a web browser." | echohl None
  end
endfunction
