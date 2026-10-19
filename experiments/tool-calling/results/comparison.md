qwen2.5-coder:3b  ->  qwen2.5-coder:3b

category    success a  success b    delta    lenient a  lenient b    delta
abstain        100.0%       0.0%  -100.0%       100.0%       0.0%  -100.0%
args             0.0%      80.0%   +80.0%         0.0%      80.0%   +80.0%
depth           33.3%      55.6%   +22.2%        33.3%      55.6%   +22.2%
select           0.0%      73.3%   +73.3%         0.0%      73.3%   +73.3%

pass -> fail (6):
  ambiguous-that-one
  draft-only-do-not-post
  missing-comment-text
  missing-issue-number
  missing-repository
  unsupported-delete-or-close

fail -> pass (6):
  comment-body-multiline
  comment-body-punctuation
  correction-changes-issue
  get-issue-details
  owner-repo-from-url
  post-comment-simple
