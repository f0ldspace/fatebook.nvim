local M = {}

M.config = {
	api_key = nil,
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	if not M.config.api_key then
		vim.notify("Fatebook: No API key found.", vim.log.levels.ERROR)
	end
end

local function url_encode(str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w%-%.%_%~ ])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "+")
	end
	return str
end

local function parse_date(date_str)
	-- Parse DD-MM-YYYY to YYYY-MM-DD
	local day, month, year = date_str:match("(%d+)%-(%d+)%-(%d+)")
	if not day or not month or not year then
		return nil, "Invalid date format. Use DD-MM-YYYY"
	end
	return string.format("%s-%s-%s", year, month, day)
end

function M.create_prediction(question, forecast, date)
	if not M.config.api_key then
		vim.notify("Fatebook: No API found.", vim.log.levels.ERROR)
		return
	end

	local forecast_num = tonumber(forecast)
	if not forecast_num or forecast_num < 0 or forecast_num > 100 then
		vim.notify("Fatebook: Forecast out of range, use between 0-100", vim.log.levels.ERROR)
		return
	end

	-- percent to decimal
	local forecast_decimal = forecast_num / 100

	-- Parse date
	local resolve_by, err = parse_date(date)
	if not resolve_by then
		vim.notify("Fatebook: " .. err, vim.log.levels.ERROR)
		return
	end

	-- all to one
	local url = string.format(
		"https://fatebook.io/api/v0/createQuestion?apiKey=%s&title=%s&resolveBy=%s&forecast=%s",
		url_encode(M.config.api_key),
		url_encode(question),
		url_encode(resolve_by),
		url_encode(tostring(forecast_decimal))
	)

	-- api call
	local cmd = string.format("curl -s -X GET '%s'", url)

	vim.fn.jobstart(cmd, {
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				vim.schedule(function()
					vim.notify(
						string.format("Fatebook: Created prediction '%s' (%d%%)", question, forecast_num),
						vim.log.levels.INFO
					)
				end)
			else
				vim.schedule(function()
					vim.notify("Fatebook: Failed to create prediction", vim.log.levels.ERROR)
				end)
			end
		end,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

return M
