import 'package:airview_tech/Home/home/home.dart';
import 'package:airview_tech/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Terms extends StatelessWidget {
  final Function()? callback;
  Terms({this.callback});

  BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Material(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Text('Conditions Générales d\'Utilisation (CGU)\n\n'
                        '1. Introduction\n'
                        'Les présentes Conditions Générales d\'Utilisation (ci-après les "CGU") régissent l\'utilisation de l\'application BuyMyTicket, '
                        'une plateforme de mise en relation entre particuliers pour la vente et l\'achat de billets de transport (avion, train, bus). En accédant à l\'Application et en '
                        'l\'utilisant, vous acceptez les présentes CGU sans réserve. Si vous n\'acceptez pas ces CGU, vous ne devez pas utiliser l\'Application.\n\n'
                        '2. Objet de l\'Application\n'
                        'L\'Application a pour seul objet de mettre en relation des utilisateurs particuliers souhaitant vendre ou acheter des billets de transport. '
                        'L\'Application n\'est ni partie à la transaction, ni intermédiaire, ni prestataire de services de transport. Les transactions effectuées via l\'Application sont '
                        'conclues directement entre les utilisateurs.\n\n'
                        '3. Responsabilité de l\'Application\n'
                        'L\'Application décline toute responsabilité quant à la validité, l\'authenticité, la disponibilité ou la légalité des billets vendus via l\'Application. BuyMyTicket ne '
                        'garantit pas la réalisation ou la qualité des transactions conclues entre les utilisateurs.\n\n'
                        '4. Responsabilité des Utilisateurs\n'
                        'Les utilisateurs sont seuls responsables des billets qu\'ils vendent ou achètent via l\'Application. Il leur incombe de vérifier la validité et la conformité des billets '
                        'aux conditions du transporteur, ainsi que de respecter les lois en vigueur.\n\n'
                        'Les utilisateurs s\'engagent à n\'utiliser l\'Application que dans le cadre légal et à ne pas proposer de billets obtenus frauduleusement ou en violation des '
                        'conditions générales des transporteurs.\n\n'
                        '5. Exclusion de Garantie\n'
                        'L\'Application est fournie "en l\'état" et sans aucune garantie de quelque nature que ce soit, explicite ou implicite. BuyMyTicket ne garantit pas que l\'Application sera '
                        'exempte d\'erreurs ou que les services seront ininterrompus. L\'utilisateur assume l\'entière responsabilité de l\'utilisation de l\'Application.\n\n'
                        '6. Limitation de Responsabilité\n'
                        'Dans toute la mesure permise par la loi, BuyMyTicket ne pourra être tenue responsable de tout dommage direct ou indirect, matériel ou immatériel, '
                        'résultant de l\'utilisation ou de l\'impossibilité d\'utiliser l\'Application, y compris en cas de perte de données, de profits, d\'opportunités ou de toute autre perte financière.\n\n'
                        '7. Données Personnelles\n'
                        'Les données personnelles collectées via l\'Application sont traitées conformément à la Politique de Confidentialité de BuyMyTicket accessible à [lien vers la Politique de Confidentialité]. '
                        'Les utilisateurs sont informés qu\'ils disposent de droits d\'accès, de rectification et de suppression de leurs données personnelles.\n\n'
                        '8. Litiges entre Utilisateurs\n'
                        'En cas de litige entre utilisateurs concernant une transaction, ceux-ci s\'engagent à tenter de résoudre leur différend à l\'amiable. BuyMyTicket ne saurait être tenue responsable '
                        'de tels litiges et n\'intervient pas dans leur résolution.\n\n'
                        '9. Modifications des CGU\n'
                        'BuyMyTicket se réserve le droit de modifier les présentes CGU à tout moment. Les modifications seront applicables dès leur publication sur l\'Application. '
                        'Les utilisateurs sont invités à consulter régulièrement les CGU pour se tenir informés des éventuelles modifications.\n\n'
                        '10. Loi Applicable et Juridiction Compétente\n'
                        'Les présentes CGU sont régies par le droit français. Tout litige relatif à l\'Application ou à l\'interprétation des CGU sera soumis à la compétence exclusive '
                        'des tribunaux.\n\n'
                        '11. Contact\n'
                        'Pour toute question relative aux présentes CGU, vous pouvez contacter notre service clientèle à l\'adresse suivante : Contact.buymyticket@gmail.com\n'),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: _buildNextBtn(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.black,
      width: double.infinity,
      child: ElevatedButton(
        style: kButtonStyle,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);

          Navigator.pushReplacement(buildContext!,
              MaterialPageRoute(builder: (context) {
            return const Home();
          }));
        },
        child: const Text(
          'I Agree',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
