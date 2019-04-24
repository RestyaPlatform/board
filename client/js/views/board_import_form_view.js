/**
 * @fileOverview This file has functions related to organization board form view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardImportForm View
 * @class BoardImportFormView
 * @constructor
 * @extends Backbone.View
 */
App.BoardImportFormView = Backbone.View.extend({
    tagName: 'ul',
    className: 'list-unstyled',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {},
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
    template: JST['templates/board_import_form_view'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({});
        this.delegateEvents(this.events);
        this.showTooltip();
        return this;
    }
});
