module github.com/HugoBlox/theme-academic-cv

go 1.15

require (
	github.com/HugoBlox/hugo-blox-builder/modules/blox-bootstrap/v5 v5.9.6
	github.com/HugoBlox/hugo-blox-builder/modules/blox-plugin-netlify v1.1.2-0.20231108141515-0478cf6921f9
	github.com/HugoBlox/hugo-blox-builder/modules/blox-plugin-reveal v1.1.2
)

// replace for develop when forked repo is in local
replace github.com/HugoBlox/hugo-blox-builder/modules/blox-bootstrap/v5 => ../hugo-blox-builder/modules/blox-bootstrap

replace github.com/HugoBlox/hugo-blox-builder/modules/blox-plugin-netlify => ../hugo-blox-builder/modules/blox-plugin-netlify

replace github.com/HugoBlox/hugo-blox-builder/modules/blox-plugin-reveal => ../hugo-blox-builder/modules/blox-plugin-reveal

replace github.com/HugoBlox/hugo-blox-builder/modules/blox-core => ../hugo-blox-builder/modules/blox-core

replace github.com/HugoBlox/hugo-blox-builder/modules/blox-seo => ../hugo-blox-builder/modules/blox-seo
