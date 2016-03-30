if (typeof App === 'undefined') {
    App = {};
}
/**
 * CheckList Item Collection
 * @class CheckListItemCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CheckListItemCollection = Backbone.Collection.extend({
    model: App.CheckListItem,
    comparator: function(item) {
        return item.get('position');
    },
    sortByColumn: function(colName) {
        this.sortKey = colName;
        this.sort();
    },
    next: function(item) {
        var filtered_items = this.where({
            checklist_id: item.attributes.checklist_id
        });
        var checklist_items = new App.CheckListItemCollection();
        checklist_items.reset(filtered_items);
        return checklist_items.at(checklist_items.indexOf(item) + 1);
    },
    previous: function(item) {
        var filtered_items = this.where({
            checklist_id: item.attributes.checklist_id
        });
        var checklist_items = new App.CheckListItemCollection();
        checklist_items.reset(filtered_items);
        return checklist_items.at(checklist_items.indexOf(item) - 1);
    }
});
