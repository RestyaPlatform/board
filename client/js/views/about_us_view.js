/**
 * @fileOverview This file has functions related to about us page view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * About us View
 * @class AboutusView
 * @constructor
 * @extends Backbone.View
 */
App.AboutusView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/about_us'],
    tagName: 'section',
    className: 'row',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    }
});
