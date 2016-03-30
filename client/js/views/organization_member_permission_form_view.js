/**
 * @fileOverview This file has functions related to organization member permission form view. This view calling from organization user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationMemberPermissionForm View
 * @class OrganizationMemberPermissionFormView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationMemberPermissionFormView = Backbone.View.extend({
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
    template: JST['templates/organization_member_permission_form'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            organization_user: this.model
        });
        this.showTooltip();
        return this;
    }
});
