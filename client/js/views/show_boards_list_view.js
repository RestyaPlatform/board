/**
 * @fileOverview This file has functions related to show board list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowAllVisibility View
 * @class ShowAllVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.ShowBoardsListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/show_boards_list'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({}));
        this.showTooltip();
        return this;
    }
});
