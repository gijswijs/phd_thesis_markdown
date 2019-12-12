$Dir = get-childitem ./source
$List = $Dir | Where-Object {$_.extension -eq ".md"}| ForEach-Object {$_.FullName} 
$List = $([string]$List).replace("\","/")
$Command = "pandoc $List -o `"C:/Repositories/phd_thesis_markdown/output/proposal-p95677.pdf`" -H `"C:/Repositories/phd_thesis_markdown/style/preamble.tex`" --template=`"C:/Repositories/phd_thesis_markdown/style/template.tex`" --bibliography=`"C:/Users/Gijs van Dam/Documents/library.bib`" --csl=`"C:/Repositories/phd_thesis_markdown/style/Gaya-UKM-2017.csl`" --highlight-style pygments --filter=`"mermaid-filter.cmd`" --lua-filter=`"C:/Repositories/phd_thesis_markdown/style/git-revision.lua`" -V fontsize=12pt -V papersize=a4paper -V documentclass=report -N --pdf-engine=xelatex --verbose"
Invoke-Expression $Command