local BASE = (...) .. '.'

return {
	core     = require(BASE .. 'core'),
	Button   = require(BASE .. 'button'),
	Slider   = require(BASE .. 'slider'),
}
