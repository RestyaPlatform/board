/**
 * @fileOverview This file has functions related to show all visibility view. This view calling from board add view, board header view and board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: visibility(String).
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
App.ShowAllVisibilityView = Backbone.View.extend({
    tagName: 'ul',
    className: 'list-unstyled',
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
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            visibility: this.model
        });
        this.delegateEvents(this.events);
        this.showTooltip();
        return this;
    }
});
