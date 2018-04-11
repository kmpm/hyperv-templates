# Based upon https://www.hanselman.com/blog/XSLTWithPowershell.aspx
# and https://stackoverflow.com/questions/37024568/applying-xsl-to-xml-with-powershell-exception-calling-transform


# . .\utils\xmlutils.ps1 ; Transform-Xml -Verbose .\addkey.xslt .\win\answer_files\2016\Autounattend.xml
# (Get-Content .\win\answer_files\2016\Autounattend.xml) -as [xml] | Transform-Xml -Verbose .\addkey.xslt

function Set-XmlTransform {
    [CmdletBinding()]
    param(
        [string]
        $xsl=$(throw '$xsl path is required'),
        
        # [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
        [string[]]
        $xmlPath
    )
        
    BEGIN {

        function applyStylesheetToXml([xml]$xml) {
            Write-Verbose "Applying Stylesheet"
            $xslt_settings = New-Object System.Xml.Xsl.XsltSettings;
            $XmlUrlResolver = New-Object System.Xml.XmlUrlResolver;
            $xslt_settings.EnableScript = 1;
            $xargs = New-Object System.Xml.Xsl.XsltArgumentList;
            $xargs.AddParam('productKey', '', 'ABC-123')

            $xslt = New-Object System.Xml.Xsl.XslCompiledTransform

            [string]::join([environment]::newline, $result)
        }

        function applyStylesheetToXmlFile($xml) {
            Write-Verbose "Applying Stylesheet to File '$xml'" 
            $rpath = resolve-path $xml
            # $result = nxslt2.exe $rpath $stylesheetPath
            # [string]::join([environment]::newline, $result)
            
            $xslt_settings = New-Object System.Xml.Xsl.XsltSettings;
            $XmlUrlResolver = New-Object System.Xml.XmlUrlResolver;
            $xslt_settings.EnableScript = 1;
            $xargs = New-Object System.Xml.Xsl.XsltArgumentList;
            $xargs.AddParam('productKey', '', 'ABC-123')

            $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
            $xslt.Load($xsl,$xslt_settings,$XmlUrlResolver);
          
            # $stream = New-Object IO.FileStream $output ,([IO.FileMode]::Create)
            $stream = New-Object System.IO.MemoryStream
            
            $writer = New-Object System.IO.StreamWriter $stream
            $writer.Write("foo");
            $writer.Flush()
            try {
                
                # $xslt.Transform($rpath, $xargs, $stream);
                Write-Verbose "size $($stream.Length)"
                $reader = New-Object System.IO.StreamReader $stream,'UFT8'
                $stream.Flush()
                $result = $reader.ReadToEnd()
                Write-Verbose $result
                if ($result -is [Array]) {
                    Write-Verbose "is array"
                    [string]::join([environment]::newline, $result)
                }
            
                Write-Verbose "Result: '$($result.ToString())'"
            }
            catch {
                Write-Host "Exception $_.Exception.Message" -ForegroundColor Green
            }
            finally {
                Write-Verbose "Closing stream"
                $stream.Close();
            }
        }
    }
   
    PROCESS {   
        Write-Verbose "Tada"
        if ($_) {
            if ($_ -is [xml]) {
                applyStylesheetToXml $_
            }
            elseif ($_ -is [IO.FileInfo]) {
                applyStylesheetToXmlFile $_.FullName
            }
            elseif ($_ -is [string]) {
                # test if valid syntax and exists as filepath
                if (Test-Path -Type Leaf -IsValid $_) {
                    applyStylesheetToXmlFile $_
                }
                else {
                    # it must be an xml string
                    applyStylesheetToXml $_
                }
            }
            else {
                throw "Pipeline input type must be one of: [xml], [string] or [IO.FileInfo]"
            }
        }
        else {
            Write-Verbose "No input provided"
        }
    }
    
    END {
        if ($xmlPath) {
            foreach ($path in $xmlPath) {
                applyStylesheetToXmlFile $path
            }
        }
    }
}

function Get-DefaultSwitchName {
    return (Get-VMSwitch -Id c08cb7b8-9b3c-408e-8e30-5e16a3aeb444).Name
}


Export-ModuleMember -Function Set-*
Export-ModuleMember -Function Get-*