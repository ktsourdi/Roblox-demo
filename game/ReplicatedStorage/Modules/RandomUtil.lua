local RandomUtil = {}

function RandomUtil.weightedRandom(weightsTable)
	-- weightsTable: { key = numberWeight }
	local total = 0
	for _, weight in pairs(weightsTable) do
		total += weight
	end
	local roll = math.random() * total
	local cumulative = 0
	for key, weight in pairs(weightsTable) do
		cumulative += weight
		if roll <= cumulative then
			return key
		end
	end
	-- fallback: return first key
	for key in pairs(weightsTable) do
		return key
	end
end

return RandomUtil

