[Back Up ⮥](./../README.md)

## TinyBits => /pwsh

- [New-SafeTimeFilename](./New-SafeFilenameTime.ps1)

```ps1
🐒> New-SafeTimeFilename
# 2025-08-25_08-31-57Z

🐒> New-SafeTimeFilename -TemplateString 'screenshot-{0}.png'
# screenshot-2025-08-25_08-31-57Z.png

🐒> New-SafeTimeFilename '{0}-main.log'
# 2025-08-25_08-31-57Z-main.log

🐒> New-SafeTimeFilename 'AutoExport-{0}.xlsx'
# AutoExport-2025-08-25_08-31-57Z.xlsx
```