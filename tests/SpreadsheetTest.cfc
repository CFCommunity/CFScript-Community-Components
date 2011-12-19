component extends="mxunit.framework.TestCase" {


	function testSpreadsheet() {
		var spreadsheet = createObject("component", "CFScript-Community-Components.spreadsheet");

		var testFile = getTempDirectory() & "spreadsheet-unittest.xls";
		if(fileExists(testFile)) {
			fileDelete(testFile);
		}

		var dataToWrite = queryNew("ColumnA,ColumnB,ColumnC");
		queryAddRow(dataToWrite, 3);
		dataToWrite.ColumnA[1] = "One";
		dataToWrite.ColumnB[1] = 1;
		dataToWrite.ColumnC[1] = "Uno";
		dataToWrite.ColumnA[2] = "Two";
		dataToWrite.ColumnB[2] = 2;
		dataToWrite.ColumnC[2] = "Dos";
		dataToWrite.ColumnA[3] = "Three";
		dataToWrite.ColumnB[3] = 3;
		dataToWrite.ColumnC[3] = "Tres";

		spreadsheet.write(
			filename = testFile,
			query = dataToWrite
		);

		var spreadsheetInfo = spreadsheet.readInfo(
			src = testFile
		);

		assertTrue(structKeyExists(spreadsheetInfo, "summaryInfo"));
		assertEquals(spreadsheetInfo.summaryInfo.sheets, 1);

		spreadsheet.update(
			filename = testfile,
			query = dataToWrite,
			sheetname = "blah"
		);

		var spreadsheetInfo = spreadsheet.readInfo(
			src = testFile
		);

		assertTrue(structKeyExists(spreadsheetInfo, "summaryInfo"));
		assertEquals(spreadsheetInfo.summaryInfo.sheets, 2);


		var spreadsheetData = spreadsheet.readQuery(
			src = testfile,
			excludeHeaderRow = true,
			headerRow = 1
		);

		assertTrue(isQuery(spreadsheetData));
		assertEquals(spreadsheetData.ColumnA[3], "Three");

		if(fileExists(testFile)) {
			fileDelete(testFile);
		}
	}

}