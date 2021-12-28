import QtQuick 2.0

ListModel {
	function addNewItem(t, d) {
		append({ time: t, day: d })
	}

	id: idAlarmMdl
}
