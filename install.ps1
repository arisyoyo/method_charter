<#
.SYNOPSIS
    安装 method-charter skill 到项目级或用户级技能目录。

.DESCRIPTION
    复制 SKILL.md、references/ 与 README.md 到
        <目标>/.dsh/skills/method-charter/
    或（-User）
        ~/.dsh/skills/method-charter/
    不修改其它任何文件，卸载即删除该目录。

.PARAMETER Target
    项目目录。默认当前目录。

.PARAMETER User
    装到用户级目录，所有项目可用。

.PARAMETER Force
    目标已存在时覆盖。

.EXAMPLE
    .\install.ps1 -Target D:\papers\my-paper

.EXAMPLE
    .\install.ps1 -User
#>
[CmdletBinding()]
param(
    [string]$Target = (Get-Location).Path,
    [switch]$User,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$source = $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
    throw "找不到 SKILL.md。请把 install.ps1 放在 skill 目录内运行（当前：$source）"
}

if ($User) {
    $root = Join-Path $env:USERPROFILE '.dsh\skills'
    $scope = '用户级（所有项目）'
}
else {
    if (-not (Test-Path -LiteralPath $Target)) {
        throw "目标目录不存在：$Target"
    }
    $root = Join-Path $Target '.dsh\skills'
    $scope = "项目级（$Target）"
}

$dest = Join-Path $root 'method-charter'

if (Test-Path -LiteralPath $dest) {
    if (-not $Force) {
        Write-Host "目标已存在：$dest"
        Write-Host "如需覆盖，加 -Force"
        exit 1
    }
    Remove-Item -LiteralPath $dest -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($item in @('SKILL.md', 'references', 'README.md')) {
    $path = Join-Path $source $item
    if (Test-Path -LiteralPath $path) {
        Copy-Item -LiteralPath $path -Destination $dest -Recurse -Force
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $dest 'SKILL.md'))) {
    throw "安装失败：$dest 下没有 SKILL.md"
}

Write-Host "已安装（$scope）：$dest"
Write-Host "下一步：新开一个会话，输入 /method-charter 验证。"
