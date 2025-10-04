if vim.g.loaded_fatebook then
	return
end
vim.g.loaded_fatebook = true

vim.api.nvim_create_user_command("Predict", function(opts)
	local fatebook = require("fatebook")

	local args = opts.args

	local question, forecast, date = args:match('^"([^"]+)"%s*,%s*(%d+)%s*,%s*([%d%-]+)$')

	if not question or not forecast or not date then
		question, forecast, date = args:match("^([^,]+),%s*(%d+)%s*,%s*([%d%-]+)$")
	end

	if not question or not forecast or not date then
		vim.notify('Fatebook: Invalid format. Use :Predict "question", 55, DD-MM-YYYY', vim.log.levels.ERROR)
		return
	end

	question = question:match("^%s*(.-)%s*$")

	fatebook.create_prediction(question, forecast, date)
end, {
	nargs = 1,
	desc = "Create a Fatebook prediction",
})
