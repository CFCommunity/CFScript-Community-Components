component extends="mxunit.framework.TestCase" {

	private struct function getTestData() {
		var queries = {};
		// Set up two test queries
		var q1 = queryNew("id,value");
		queryAddRow(q1);
		querySetCell(q1, "id", 1);
		querySetCell(q1, "value", "loo");
		queryAddRow(q1);
		querySetCell(q1, "id", 2);
		querySetCell(q1, "value", "foo");
		queryAddRow(q1);
		querySetCell(q1, "id", 3);
		querySetCell(q1, "value", "zoo");

		var q2 = queryNew("id,othervalue");
		queryAddRow(q2);
		querySetCell(q2, "id", 1);
		querySetCell(q2, "othervalue", "boo");
		queryAddRow(q2);
		querySetCell(q2, "id", 3);
		querySetCell(q2, "othervalue", "too");
		queryAddRow(q2);
		querySetCell(q2, "id", 44);
		querySetCell(q2, "othervalue", "moo");
		
		queries.q1 = q1;
		queries.q2 = q2;
		return queries;
	}

	function testQueryOfQueries() {
		data = getTestData();
		
		// This is how you use the QoQ component
		var queryResults = createObject("component", "CFScript-Community-Components.queryofqueries").init(
			SQL = "select * from q1, q2 where q1.id = q2.id",
			q1 = data.q1,
			q2 = data.q2
		);

		assertEquals(queryResults.recordcount, 2);

		var queryResults = createObject("component", "CFScript-Community-Components.queryofqueries").init(
			SQL = "select * from q1 where id = 2",
			q1 = data.q1,
			q2 = data.q2
		);

		assertEquals(queryResults.recordcount, 1);

		var queryResults = createObject("component", "CFScript-Community-Components.queryofqueries").init(
			SQL = "select * from q1, q2 where q1.id = q2.id and q1.id < 4",
			q1 = data.q1,
			q2 = data.q2
		);

		assertEquals(queryResults.recordcount, 2);
	}

}