if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card CheckList Collection
 * @class CardCheckListCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardCheckListCollection = Backbone.Collection.extend({
    model: App.CheckList,
    comparator: function(checklist) {
        return checklist.get('position');
    },
    sortByColumn: function(colName) {
        this.sortKey = colName;
        this.sort();
    },
    next: function(checklist) {
        var filtered_checklists = this.where({
            card_id: checklist.attributes.card_id
        });
        var checklists = new App.CardCheckListCollection();
        checklists.reset(filtered_checklists);
        return checklists.at(checklists.indexOf(checklist) + 1);
    },
    previous: function(checklist) {
        var filtered_checklists = this.where({
            card_id: checklist.attributes.card_id
        });
        var checklists = new App.CardCheckListCollection();
        checklists.reset(filtered_checklists);
        return checklists.at(checklists.indexOf(checklist) - 1);
    }
});
