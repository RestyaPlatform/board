/**
 * @fileOverview This file has functions related to copy board visibility view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board name.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CopyBoardVisibility View
 * @class CopyBoardVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.CopyBoardVisibilityView = Backbone.View.extend({
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
    template: JST['templates/show_all_visibility'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            name: this.model,
        }));
        this.showTooltip();
        return this;
    }
});
