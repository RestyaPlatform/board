/**
 * @fileOverview This file has functions related to organization visibility form view. This view calling from organization header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationVisibilityForm View
 * @class OrganizationVisibilityFormView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationVisibilityFormView = Backbone.View.extend({
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
    template: JST['templates/organization_visibility_form'],
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
            organization: this.model
        });
        this.showTooltip();
        return this;
    }
});
