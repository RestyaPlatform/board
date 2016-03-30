/**
 * @fileOverview This file has functions related to move cards form list view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list collection.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * MoveCardsFromList View
 * @class MoveCardsFromListView
 * @constructor
 * @extends Backbone.View
 */
App.MoveCardsFromListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.filtered_lists = options.filtered_lists;
        this.render();
    },
    template: JST['templates/move_cards_from_list'],
    tagName: 'ul',
    className: 'list-unstyled',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            list: this.model,
            filtered_lists: this.filtered_lists
        });
        this.delegateEvents(this.events);
        this.showTooltip();
        return this;
    }
});
