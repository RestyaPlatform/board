/**
 * @fileOverview This file has functions related to user board list view. This view calling from user index view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardLabelsForm View
 * @class CardLabelsFormView
 * @constructor
 * @extends Backbone.View
 */
App.UserBoardListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/user_board_list'],
    tagName: 'li',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user_board: this.model,
        }));
        this.showTooltip();
        return this;
    }
});
