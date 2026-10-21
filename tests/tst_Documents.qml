import QtQuick
import QtTest
import ".."
Item {
 width: 1440; height: 705
 Documents { id: docs; anchors.fill: parent }
 TestCase {
  name: "DocumentsTable"; when: windowShown
  function find(item, name) { if(item.objectName === name) return item; for(var i=0;i<item.children.length;i++) { var r=find(item.children[i],name); if(r) return r } return null }
  function test_filterCounts() {
   var initialChips = docs.chips.slice()
   compare(docs.resultCount, 20)
   compare(docs.rowOrder.length, 20)
   compare(docs.pageCount, 2)
   var selectAll = findChild(docs, "selectAllSpecimens")
   verify(!selectAll.checked)
   mouseClick(selectAll)
   compare(docs.selected.length, 20)
   verify(selectAll.checked)
   docs.page = 2
   var previous = docs.resultCount
   while (docs.chips.length) {
    docs.removeChip(0)
    verify(docs.resultCount > previous)
    compare(docs.rowOrder.length, docs.resultCount)
    compare(docs.page, 1)
    verify(!selectAll.checked)
    previous = docs.resultCount
   }
   compare(docs.resultCount, 35)
   docs.chips = initialChips.slice()
   compare(docs.resultCount, 20)
   docs.clearFilters()
   compare(docs.resultCount, 35)
   compare(docs.pageCount, 4)
   mouseClick(selectAll)
   compare(docs.selected.length, 35)
   verify(selectAll.checked)
   docs.chips = initialChips
   compare(docs.selected.length, 20)
   compare(docs.resultCount, 20)
   docs.toggleRow(19)
   verify(!selectAll.checked)
   docs.selected = [0, 2, 4]
  }
  function test_filterPanels() {
   var programs = findChild(docs, "programFilterPopup")
   var dates = findChild(docs, "dateFilterPopup")
   verify(programs !== null); verify(dates !== null)
   mouseClick(find(docs, "documentFilter1"))
   tryCompare(programs, "opened", true)
   var name = programs.programs[2].name
   programs.toggle(name)
   verify(docs.chips.indexOf(name) >= 0)
   var search = findChild(programs, "programSearch")
   search.text = "Brakes"
   verify(programs.matches(programs.programs[3]))
   verify(!programs.matches(programs.programs[0]))
   programs.close()
   docs.removeChip(docs.chips.indexOf(name))
   compare(programs.selectedPrograms.length, 0)
   mouseClick(find(docs, "documentFilter4"))
   tryCompare(dates, "opened", true)
   dates.today = new Date(2026, 9, 17)
   dates.choose(new Date(2026, 7, 31)); dates.choose(new Date(2026, 7, 16))
   compare(dates.rangeStart.getDate(), 16); compare(dates.rangeEnd.getDate(), 31)
   dates.confirmRange()
   verify(docs.dateChip.indexOf("16 Aug 2026") >= 0)
   verify(docs.chips.indexOf(docs.dateChip) >= 0)
   dates.open(); dates.preset(4); dates.close(); dates.open()
   compare(dates.rangeStart.getFullYear(), 2026)
   for(var preset=0; preset<5; preset++) { dates.preset(preset); verify(dates.rangeStart.getTime() <= dates.rangeEnd.getTime()) }
   dates.today = new Date(2026, 0, 1); dates.preset(0)
   compare(Qt.formatDate(dates.rangeStart,"yyyy-MM-dd"), "2025-12-22")
   compare(Qt.formatDate(dates.rangeEnd,"yyyy-MM-dd"), "2025-12-28")
   dates.close(); docs.clearFilters()
   compare(dates.appliedStart, null); compare(docs.chips.length, 0)
  }
  function test_paginationFitsRows() {
   var frame = findChild(docs, "specimenTableFrame")
   var footer = findChild(docs, "specimenPagination")
   docs.pageSize = 5; docs.page = 1
   tryCompare(frame, "height", 216)
   verify(Math.abs(footer.mapToItem(frame,0,0).y - frame.height - 16) < 1)
   docs.pageSize = 10; docs.page = 4
   tryCompare(frame, "height", 216)
   docs.pageSize = 20; docs.page = 2
   tryCompare(findChild(docs,"specimenViewport"), "contentHeight", 576)
   verify(frame.height <= 576)
   docs.pageSize = 10; docs.page = 1
  }
  function test_stickyHeaders() {
   docs.pageSize = 20; docs.page = 1
   var viewport = findChild(docs,"specimenViewport")
   var header = findChild(docs,"stickySpecimenHeader")
   var rows = findChild(docs,"specimenRows")
   wait(50)
   var headerY = header.mapToItem(docs,0,0).y
   var rowY = rows.itemAt(0).mapToItem(docs,0,0).y
   viewport.contentY = 100
   compare(header.mapToItem(docs,0,0).y,headerY)
   compare(rows.itemAt(0).mapToItem(docs,0,0).y,rowY-100)
   viewport.contentX = 40
   compare(header.x,-40)
   viewport.contentX = 0; viewport.contentY = 0
   docs.pageSize = 10; docs.page = 1
  }
  function test_tableInteractions() {
   var original = docs.selected.slice().join(",")
   for(var col=0;col<10;col++) {
    docs.sortColumn=-1
    docs.sortBy(col)
    compare(docs.sortColumn,col); verify(docs.sortAscending)
    var asc=docs.rowOrder.slice()
    docs.sortBy(col); verify(!docs.sortAscending)
    compare(docs.rowOrder.length,35)
    for(var i=1;i<35;i++) {
     var av=docs.sortValue(asc[i-1],col), bv=docs.sortValue(asc[i],col)
     if(av === null || bv === null) continue
     verify(typeof av === "number" ? av <= bv : av.localeCompare(bv,undefined,{numeric:true,sensitivity:"base"}) <= 0)
    }
   }
   compare(docs.selected.join(","),original)
   var header=find(docs,"columnHeader0")
   mouseClick(header,header.width/2,18)
   compare(docs.sortColumn,0); verify(docs.sortAscending)
   mouseClick(header,header.width/2,18)
   verify(!docs.sortAscending); compare(docs.rowOrder[0],34)
   var target=find(docs,"columnHeader1")
   var endpoint=target.mapToItem(header,target.width/2,18)
   mouseDrag(header,header.width/2,18,endpoint.x-header.width/2,0,Qt.LeftButton)
   tryCompare(docs,"draggingColumn",-1)
   compare(docs.columnOrder[0],1); compare(docs.columnOrder[1],0)
   compare(docs.sortColumn,0); verify(!docs.sortAscending)
   docs.pageSize=5; docs.page=7
   compare(find(docs,"specimenRows").itemAt(0).number,4)
   compare(docs.selected.join(","),original)
  }
 }
}
