
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:simple_app/main.dart';

class MockLoginCubit extends MockCubit<void> implements LoginCubit {}

void main() {
	group('Main Entry Point Tests', () {
		testWidgets('App starts with LoginScreen', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());

			expect(find.text('Login'), findsOneWidget);
			expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password fields
			expect(find.text('Login'), findsOneWidget);
		});

		testWidgets('Navigates to HomeScreen on successful login', (WidgetTester tester) async {
			final mockLoginCubit = MockLoginCubit();

			whenListen(mockLoginCubit, Stream<void>.fromIterable([LoginSuccess()]));

			await tester.pumpWidget(
				BlocProvider<LoginCubit>(
					create: (_) => mockLoginCubit,
					child: MyApp(),
				),
			);

			await tester.pumpAndSettle();

			expect(find.text('Logout'), findsOneWidget);
		});

		testWidgets('Displays email and password fields on LoginScreen', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());

			expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password fields
		});

		testWidgets('Displays Logout button on HomeScreen', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());

			await tester.pumpAndSettle();

			expect(find.text('Logout'), findsOneWidget);
		});

		testWidgets('Navigates back to LoginScreen on logout', (WidgetTester tester) async {
			final mockLoginCubit = MockLoginCubit();

			whenListen(mockLoginCubit, Stream<void>.fromIterable([LogoutSuccess()]));

			await tester.pumpWidget(
				BlocProvider<LoginCubit>(
					create: (_) => mockLoginCubit,
					child: MyApp(),
				),
			);

			await tester.tap(find.text('Logout'));
			await tester.pumpAndSettle();

			expect(find.text('Login'), findsOneWidget);
		});
	});
}
