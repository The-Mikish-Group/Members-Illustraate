﻿using Members.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text.RegularExpressions;

namespace Members.Controllers
{
    public partial class FileController : Controller // Make the class partial
    {
        private readonly string _protectedFilesPath;
        private readonly ILogger<FileController> _logger;

        public FileController(IWebHostEnvironment env, ILogger<FileController> logger)
        {
            _protectedFilesPath = Path.Combine(env.ContentRootPath, "ProtectedFiles");
            _logger = logger;
            _logger.LogInformation("ProtectedFilesPath: {ProtectedFilesPath}", _protectedFilesPath);
        }

        private string GetFilePath(string fileName)
        {
            return Path.Combine(_protectedFilesPath, fileName);
        }

        public IActionResult DownloadPdf(string fileName)
        {
            var filePath = GetFilePath(fileName);

            if (!System.IO.File.Exists(filePath))
            {
                return NotFound($"File not found: {fileName}");
            }

            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            return File(fileBytes, "application/pdf", fileName);
        }

        public IActionResult ViewPdf(string fileName)
        {
            var filePath = GetFilePath(fileName);

            if (!System.IO.File.Exists(filePath))
            {
                return NotFound($"File not found: {fileName}");
            }

            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            return File(fileBytes, "application/pdf");
        }

        // Existing action for Budget and Financial Files
        public IActionResult GetBudgetFinancialFiles()
        {
            if (!Directory.Exists(_protectedFilesPath))
            {
                const string errorMessage = "Protected files directory not found: {Path}";
                _logger.LogError(errorMessage, _protectedFilesPath);
                return Json(new List<DocumentInfo>());
            }

            var files = Directory.GetFiles(_protectedFilesPath)
                                    .Where(file => Path.GetFileName(file).StartsWith("Budget") || Path.GetFileName(file).StartsWith("Financial"))
                                    .Where(file => Path.GetExtension(file).Equals(".pdf", StringComparison.OrdinalIgnoreCase)) // Ensure only PDF files are listed
                                    .OrderBy(Path.GetFileName)
                                    .Select(filePath => new DocumentInfo
                                    {
                                        FileName = Path.GetFileName(filePath),
                                        DisplayName = Path.GetFileNameWithoutExtension(filePath)
                                                                                    .Replace("Budget Report", "Budget Report")
                                                                                    .Replace("Financial Report", "Financial Report")
                                                                                    .Trim()
                                    })
                                    .ToList();

            return Json(files);
        }

        // New action to get the list of Directory files
        public IActionResult GetDirectoryFiles()
        {
            if (!Directory.Exists(_protectedFilesPath))
            {
                const string errorMessage = "Protected files directory not found: {Path}";
                _logger.LogError(errorMessage, _protectedFilesPath);
                return Json(new List<DocumentInfo>());
            }

            var files = Directory.GetFiles(_protectedFilesPath)
                                    .Select(filePath => new DocumentInfo
                                    {
                                        FileName = Path.GetFileName(filePath),
                                        DisplayName = Path.GetFileName(filePath)
                                                            .Replace("Directory-", "") // Simplified Substring
                                                            .Replace(".pdf", "")
                                                            .Trim() // Remove "Directory-" prefix and extension
                                    })
                                    .Where(doc => !string.IsNullOrEmpty(doc.FileName) && doc.FileName.StartsWith("Directory", StringComparison.OrdinalIgnoreCase) && doc.FileName.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase))
                                    .OrderBy(doc => doc.FileName)
                                    .ToList();

            return Json(files);
        }
        // New action to get the list of Minutes files
        public IActionResult GetMinutesFiles()
        {
            if (!Directory.Exists(_protectedFilesPath))
            {
                const string errorMessage = "Protected files directory not found: {Path}";
                _logger.LogError(errorMessage, _protectedFilesPath);
                return Json(new List<DocumentInfo>());
            }

            var files = Directory.GetFiles(_protectedFilesPath)
                                    .Where(file => Path.GetFileName(file).StartsWith("Minutes") || Path.GetFileName(file).StartsWith("Agenda"))
                                    .Where(file => Path.GetExtension(file).Equals(".pdf", StringComparison.InvariantCultureIgnoreCase)) // Ensure only PDF files are listed
                                    .OrderBy(Path.GetFileName)
                                    .Select(filePath => new DocumentInfo
                                    {
                                        FileName = Path.GetFileName(filePath),
                                        DisplayName = Path.GetFileNameWithoutExtension(filePath)
                                                                                    .Replace("Minutes", "Minutes")
                                                                                    .Replace("Agenda", "Agenda")
                                                                                    .Trim()
                                    })
                                    .ToList();

            return Json(files);
        }

        // New action to get the list of Documents files
        public IActionResult GetDocumentsFiles()
        {
            if (!Directory.Exists(_protectedFilesPath))
            {
                const string errorMessage = "Protected files directory not found: {Path}";
                _logger.LogError(errorMessage, _protectedFilesPath);
                return Json(new List<DocumentInfo>());
            }

            var files = Directory.GetFiles(_protectedFilesPath)
                                    .Select(Path.GetFileName)
                                    .Where(fileName => !string.IsNullOrEmpty(fileName) && DocumentFileNameRegex().IsMatch(fileName))
                                    .OrderBy(fileName => fileName)
                                    .Select(fileName => new DocumentInfo
                                    {
                                        FileName = fileName,
                                        DisplayName = fileName // We will format this in the view
                                    })
                                    .ToList();

            return Json(files);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Manager")]
        public IActionResult UploadFile(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            if (!file.FileName.ToLowerInvariant().EndsWith(".pdf"))
            {
                return BadRequest("Only PDF files are allowed.");
            }

            var fileName = Path.GetFileName(file.FileName);

            if (fileName.StartsWith("Minutes"))
            {
                // Regex to match "Minutes YEAR-MM-DD.pdf"
                string minutesPattern = @"^Minutes\s\d{4}-\d{2}-\d{2}\.pdf$";
                if (!Regex.IsMatch(fileName, minutesPattern))
                {
                    return BadRequest("Minutes file name must follow the format: Minutes YEAR-MM-DD.pdf (e.g., Minutes 2023-12-31.pdf)");
                }
            }
            else if (fileName.StartsWith("Agenda"))
            {
                // For now, we'll keep the simpler check for Agenda, but you can add a specific format if needed later.
            }
            else if (fileName.StartsWith("Financial Report"))
            {
                // Regex to match "Financial Report YEAR-MM.pdf"
                string financialPattern = @"^Financial Report\s\d{4}-\d{2}\.pdf$";
                if (!Regex.IsMatch(fileName, financialPattern))
                {
                    return BadRequest("Financial Report file name must follow the format: Financial Report YEAR-MM.pdf (e.g., Financial Report 2024-03.pdf)");
                }
            }
            else if (fileName.StartsWith("Budget Report"))
            {
                // Regex to match "Budget Report YEAR.pdf"
                string budgetPattern = @"^Budget Report\s\d{4}\.pdf$";
                if (!Regex.IsMatch(fileName, budgetPattern))
                {
                    return BadRequest("Budget Report file name must follow the format: Budget Report YEAR.pdf (e.g., Budget Report 2025.pdf)");
                }
            }
            else if (!DocumentFileNameRegex().IsMatch(fileName)) // Validate for document filename format on upload
            {
                return BadRequest("Document file name must start with '###-' followed by the filename and end with '.pdf' (e.g., 001-MyDocument.pdf).");
            }

            var filePath = GetFilePath(fileName);

            try
            {
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    file.CopyTo(stream);
                }
                return Ok("File uploaded successfully.");
            }
            catch (Exception ex)
            {
                const string errorMessage = "Error uploading file '{FileName}': {ErrorMessage}";
                _logger.LogError(errorMessage, fileName, ex.Message);
                return StatusCode(500, $"Error uploading file: {ex.Message}");
            }
        }

        [GeneratedRegex(@"^\d{3}-.*\.pdf$", RegexOptions.IgnoreCase)]
        private static partial Regex DocumentFileNameRegex();
    }
}