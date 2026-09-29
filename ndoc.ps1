# Script ndoc.ps1

$goal = if ($args.Count -gt 0) { $args } else { "delivery" }
docker exec ndoc make -j4 $goal
