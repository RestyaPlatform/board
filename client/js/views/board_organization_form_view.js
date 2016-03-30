/**
 * @fileOverview This file has functions related to board organization form view.
 * This view calling from board header view, board simple view, board organization foem view and orgaiztion board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations collection
 *	this.board						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardOrganizationForm View
 * @class BoardOrganizationFormView
 * @constructor
 * @extends Backbone.View
 */
App.BoardOrganizationFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.board = options.board;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/board_organization_form'],
    tagName: 'li',
    className: 'col-xs-12',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            organizations: this.model,
            board: this.board
        }));
        this.showTooltip();
        return this;
    }
});
