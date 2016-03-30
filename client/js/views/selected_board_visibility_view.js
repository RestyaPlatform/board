/**
 * @fileOverview This file has functions related to select board visibility view. This view calling from board add view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board name.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserIndexContainer View
 * @class UserIndexContainerView
 * @constructor
 * @extends Backbone.View
 */
App.SelectedBoardVisibilityView = Backbone.View.extend({
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
    template: JST['templates/selected_board_visibility'],
    tag: 'span',
    className: 'js-visibility-container',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            name: this.model
        }));
        this.showTooltip();
        return this;
    }
});
