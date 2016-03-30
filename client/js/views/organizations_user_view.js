/**
 * @fileOverview This file has functions related to organizations user view. This view calling from organization view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organization model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationsUser View
 * @class OrganizationsUserView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationsUserView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.organizations_users.bind('change:id add', this.render, this);
        this.render();
    },
    template: JST['templates/organizations_user_view'],
    tagName: 'article',
    id: 'organizations_user_view',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {

        'keyup .js-organization-users-search': 'organizationUsersSearch',
        'click .js-add-organization-member': 'addOrganizationMember',
        'click .js-delete-organization-member': 'deleteOrganizationMember',
        'click .js-show-organization-member-permission-form': 'showOrganizationMemberPermissionForm',
        'click .js-no-action': 'noAction',
        'keypress input[type=text]': 'onEnter',
        'click .js-add-member-dropdown': 'clearMemberList'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.model.organizations_users.showImage = this.showImage;
        this.$el.html(this.template({
            organization: this.model,
            organizations_users: this.model.organizations_users,
        }));
        this.showTooltip();
        return this;
    },
    /**
     * clearMemberList()
     * clear search user list
     * @param e
     * @type Object(DOM event)
     */
    clearMemberList: function(e) {
        var self = this;
        self.$('.js-organization-member-search-response').nextAll().remove();
        self.$('.js-organization-member-search-response').after('<li class="small col-xs-12">' + i18next.t('Search for a person in %s by name or email address.', {
            postProcess: 'sprintf',
            sprintf: [SITE_NAME]
        }) + '</li>');
    },
    /**
     * organizationUsersSearch()
     * display search user list
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    organizationUsersSearch: function(e) {
        var self = this;
        var q = $(e.target).val();
        if (q !== '') {
            var users = new App.UserCollection();
            users.url = api_url + 'users/search.json';
            users.fetch({
                data: {
                    organizations: this.model.id,
                    q: q
                },
                success: function() {
                    self.$('.js-organization-member-search-response').nextAll().remove();
                    _.each(users.models, function(user) {
                        var org_user = self.model.organizations_users.findWhere({
                            organization_id: self.model.id,
                            user_id: user.id
                        });
                        if (_.isUndefined(org_user)) {
                            $(new App.UserSearchResultView({
                                model: user
                            }).el).insertAfter(self.$el.find('.js-organization-member-search-response'));
                        }
                    });
                    if (users.length === 0) {
                        $(new App.UserSearchResultView({
                            model: null
                        }).el).insertAfter(self.$el.find('.js-organization-member-search-response'));
                    }
                }
            });
        }
    },
    /**
     * addOrganizationMember()
     * add member in organization
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addOrganizationMember: function(e) {
        e.preventDefault();
        var self = this;
        var organizations_user = new App.OrganizationsUser();
        var user_id = $(e.currentTarget).data('user-id');
        $(e.currentTarget).remove();
        organizations_user.url = api_url + 'organizations/' + self.model.id + '/users/' + user_id + '.json';
        //this.model.organizations_users.add(organizations_user);
        organizations_user.save({
            organization_id: self.model.id,
            user_id: user_id,
            organization_user_role_id: 2
        }, {
            success: function(model, response) {
                organizations_user.set(response.organizations_users);
                organizations_user.set('organization_id', self.model.id);
                organizations_user.set('user_id', parseInt(user_id));
                organizations_user.set('organization_user_role_id', 2);
                organizations_user.set('id', parseInt(response.id));
                self.model.organizations_users.add(organizations_user);
            }
        });
        return false;
    },
    /**
     * deleteOrganizationMember()
     * remove organization member
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteOrganizationMember: function(ev) {
        var self = this;
        var target = $(ev.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        target.parents('li.dropdown').removeClass('open');
        self.model.organizations_users.remove(self.model.organizations_users.get(parseInt(organizations_user_id)));
        self.flash('success', i18next.t('User removed from this organization'));
        self.render();
        var organizationsUser = new App.OrganizationsUser();
        organizationsUser.url = api_url + 'organizations/' + self.model.id + '/organizations_users/' + organizations_user_id + '.json';
        organizationsUser.set('id', organizations_user_id);
        organizationsUser.destroy();
        return false;
    },
    /**
     * showOrganizationMemberPermissionForm()
     * display organization member permission form
     * @param e
     * @type Object(DOM event)
     */
    showOrganizationMemberPermissionForm: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        var organizationsUser = this.model.organizations_users.findWhere({
            id: parseInt(organizations_user_id)
        });
        organizationsUser.organization_user_role_id = this.model.organization_user_role_id;
        organizationsUser.organizations_user_id = organizations_user_id;
        organizationsUser.organization_user_roles = this.model.organization_user_roles;
        organizationsUser.acl_links = this.model.acl_links;
        $('.js-show-organization-member-permission-form-response').html(new App.OrganizationMemberPermissionFormView({
            model: organizationsUser
        }).el);
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    onEnter: function(e) {
        if (e.which === 13) {
            var form = $(e.target).closest('form');
            if (form.attr('name') === 'cardAddForm') {
                $('input[type=submit]', form).trigger('click');
            } else {
                return false;
            }
        }
    }
});
