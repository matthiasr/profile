/**
	{
		"api":1,
		"name":"Split Lines On Space",
		"description":"Splits all lines on whitespace, like piping through xargs -n 1",
		"author":"matthiasr",
		"icon":"collapse",
		"tags":"split, space",
		"bias": 0.0
	}
**/

function main(input) {
	input.text = input.text.split(/[\s]+/).join('\n')
}
