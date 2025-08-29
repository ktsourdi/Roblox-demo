local RateLimiter = {}

function RateLimiter.new(defaultWindowSeconds, defaultMax)
	local self = {
		_defaultWindow = defaultWindowSeconds or 2,
		_defaultMax = defaultMax or 5,
		_buckets = {}, -- key -> {windowStart, count}
	}

	function self:_now()
		return os.clock()
	end

	function self:_getBucket(key)
		local b = self._buckets[key]
		if not b then
			b = { windowStart = self:_now(), count = 0 }
			self._buckets[key] = b
		end
		return b
	end

	function self:allow(key, windowSeconds, maxInWindow)
		local window = windowSeconds or self._defaultWindow
		local max = maxInWindow or self._defaultMax
		local b = self:_getBucket(key)
		local now = self:_now()
		if now - b.windowStart > window then
			b.windowStart = now
			b.count = 0
		end
		if b.count < max then
			b.count += 1
			return true
		end
		return false
	end

	return self
end

return RateLimiter

