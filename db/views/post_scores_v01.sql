WITH matching_interest_scores AS (
  -- For each user and post, sum the product of the weights for matching interests.
  SELECT 
    ui.interestable_id AS user_id,
    pi.interestable_id AS post_id,
    SUM(ui.weight * pi.weight) AS matching_score
  FROM interest_relations ui
  JOIN interest_relations pi
    ON ui.interest_id = pi.interest_id
  WHERE ui.interestable_type = 'User'
    AND pi.interestable_type = 'Post'
  GROUP BY ui.interestable_id, pi.interestable_id
)
SELECT 
  mis.user_id,
  mis.post_id,
  (
    (0.5 * COALESCE(mis.matching_score, 0)) +
    (0.3 * (p.likes_count * 2 + p.comments_count * 3)) -
    (0.2 * LOG(1 + EXTRACT(EPOCH FROM (NOW() - p.created_at)) / 3600))
  ) AS final_score
FROM matching_interest_scores mis
JOIN posts p ON mis.post_id = p.id;